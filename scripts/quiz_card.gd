extends Button

@export var quiz_info: QuizInfo

@onready var name_label: Label = $VBoxContainer/NameLabel
@onready var theme_label: Label = $VBoxContainer/ThemeLabel
@onready var image_rect: TextureRect = $VBoxContainer/ImageRect
@onready var score_label: Label = $VBoxContainer/ScoreLabel
@onready var questions_label: Label = $VBoxContainer/QuestionsLabel

const MAIN = preload("res://scenes/main.tscn")

func _ready() -> void:
	if !quiz_info: return
	name_label.text = quiz_info.name
	theme_label.text = quiz_info.theme
	score_label.text = "Recordes: %.1f" % quiz_info.best_score
	questions_label.text = "N° de Perguntas: %d" % quiz_info.question_count
	var image_request := ImageRequest.new()
	add_child(image_request)
	print(quiz_info.img_url)
	image_rect.texture = await image_request.get_image("http://%s/%s" % [OS.get_environment("host"), quiz_info.img_url])
	image_request.queue_free()

func _on_pressed() -> void:
	var current = get_tree().current_scene
	var quiz_request := QuizRequest.new()
	add_child(quiz_request)
	var new_scene = MAIN.instantiate()
	new_scene.quiz = await quiz_request.get_quiz(quiz_info.id)
	get_tree().root.add_child(new_scene)
	current.queue_free()
