extends Control

@onready var question_label: Label = $QuestionLabel
@onready var answer_btn_0: Button = $AnswersContainer/AnswerButton0
@onready var answer_btn_1: Button = $AnswersContainer/AnswerButton1
@onready var answer_btn_2: Button = $AnswersContainer/AnswerButton2
@onready var answer_btn_3: Button = $AnswersContainer/AnswerButton3
@onready var answers_container: GridContainer = $AnswersContainer
@onready var question_timer: Timer = $QuestionTimer
@onready var time_bar: ColorRect = $TimeBar
@onready var end_panel: PanelContainer = $EndPanel
@onready var end_label: Label = $EndPanel/MarginContainer/EndLabel
@onready var score_label: Label = $ScoreLabel
@onready var question_image: TextureRect = $QuestionImage
@onready var question_number: Label = $QuestionNumber
@onready var menu_button: Button = $EndPanel/MarginContainer/MenuButton
@onready var next_question_timer: Timer = $NextQuestion
@onready var right_wrong: TextureRect = $RightWrong

var right = preload("res://assets/imgs/Correct.jpg")
var wrong = preload("res://assets/imgs/Wrong.jpg")
var time_up = preload("res://assets/imgs/TimeUp.png")

@export var quiz: Quiz

@export var current_question: int = 0 :
	set(value):
		if quiz.questions.size() > 0:
			question_label.text = quiz.questions[value].question
			for i in range(quiz.questions[value].answers.size()):
				answers_container.get_child(i).text = quiz.questions[value].answers[i]
				answers_container.get_child(i).visible = true
			for i in range(quiz.questions[value].answers.size(), 8):
				answers_container.get_child(i).visible = false
			if quiz.questions[value].img_url:
				var image_request := ImageRequest.new()
				add_child(image_request)
				question_image.texture = await image_request.get_image("http://%s/%s" % [OS.get_environment("host"), quiz.questions[value].img_url])
				image_request.queue_free()
			else:
				question_label.position.y = 200
			current_question = value

var end_text = "Parabéns, você acertou \n %d de %d questões!!!\nE fez um total de\n%10.1f pontos!!!"
var correct_answered: Array[int]
var score: float = 0.0

enum States {
	START,
	RUN,
	STOP,
	END
}
var game_state: States = States.START

func _ready() -> void:
	for child in answers_container.get_children():
		child.answer_pressed.connect(_on_answer_pressed, 1)
	current_question = 0
	
	game_state = States.RUN
	question_timer.start()

func _process(delta: float) -> void:
	if !question_timer.is_stopped():
		time_bar.size.x = (question_timer.time_left / question_timer.wait_time) * 1152.0
	score_label.text = str(snappedf(score, 0.1))
	question_number.text = "%d/%d" % [current_question + 1, quiz.questions.size()]
	
func _on_answer_pressed(answer: int) -> void:
	if game_state != States.RUN: return
	
	if answer == quiz.questions[current_question].correct && game_state == States.RUN:
		score += (question_timer.time_left / question_timer.wait_time) * 100
		correct_answered.push_back(current_question)
		right_wrong.texture = right
	else: 
		right_wrong.texture = wrong	
		
	show_answer()

func _on_question_timer_timeout() -> void:
	show_answer()

func show_answer() -> void:
	game_state = States.STOP
	question_timer.stop()
	next_question_timer.start()
	right_wrong.visible = true;
	print(score)

func _on_next_question_timeout() -> void:
	right_wrong.visible = false;
	right_wrong.texture = time_up
	progress_game()

func progress_game() -> void:
	if current_question < quiz.questions.size() - 1:
		game_state = States.RUN
		current_question += 1
		question_timer.start(0.0)
	else:
		end_game()

func end_game() -> void:
	if game_state != States.STOP: return
	
	question_timer.stop()
	end_label.text = end_text % [correct_answered.size(), quiz.questions.size(), score]
	end_panel.visible = true
	menu_button.visible = true
	game_state = States.END

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
	queue_free()
	
