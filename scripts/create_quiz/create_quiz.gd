extends Control

const QUESTION_PANEL = preload("res://scenes/create_quiz/question_panel.tscn")

var quiz := Quiz.new()
@onready var create_question: HBoxContainer = $CreateQuestion
@onready var questions_container: HBoxContainer = $ScrollContainer/CreateQuestion/QuestionsContainer
@onready var image_rect: TextureRect = $ImageRect

var img_list: Array[String] = []
var img_name_list: Array[String] = []

func _on_name_input_text_changed(new_text: String) -> void:
	quiz.name = new_text

func _on_theme_input_text_changed(new_text: String) -> void:
	quiz.theme = new_text

func _on_new_question_button_pressed() -> void:
	var new_question_panel := QUESTION_PANEL.instantiate()
	questions_container.add_child(new_question_panel)
	quiz.questions.append(new_question_panel.question)

func _on_submit_button_pressed() -> void:
	var quiz_request := QuizRequest.new()
	add_child(quiz_request)
	await quiz_request.save_quiz(quiz)
	quiz_request.queue_free()

func _on_upload_button_pressed() -> void:
	$FileDialog.popup()

func _on_upload_button_loaded(file_name: String, file_type: String, base64_data: String) -> void:
	quiz.img_data = base64_data
	quiz.img_type = file_type.replace("image/", "")
	var data = Marshalls.base64_to_raw(base64_data)
	var image = Image.new()
	match quiz.img_type:
		"jpg", "jpeg":
			image.load_jpg_from_buffer(data)
		"png":
			image.load_png_from_buffer(data)
		"webp":
			image.load_webp_from_buffer(data)
		"svg":
			image.load_svg_from_buffer(data)
	var texture = ImageTexture.create_from_image(image)
	image_rect.texture = texture

func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/quiz_selection.tscn")
