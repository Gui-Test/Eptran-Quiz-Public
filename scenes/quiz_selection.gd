extends Control

const QUIZ_CARD = preload("res://scenes/quiz_card.tscn")
@onready var quiz_container: HBoxContainer = $ScrollContainer/QuizContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var quiz_request := QuizRequest.new()
	add_child(quiz_request)
	
	var quiz_list = await quiz_request.get_quizes()
	
	for quiz in quiz_list:
		var new_card = QUIZ_CARD.instantiate()
		new_card.quiz_info = quiz
		quiz_container.add_child(new_card)

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/create_quiz/create_quiz.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
