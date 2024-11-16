extends PanelContainer

const ANSWER_INPUT = preload("res://scenes/create_quiz/answer_input.tscn")

var question := Question.new()
@onready var answers_container: VBoxContainer = $Container/ScrollContainer/AnswersContainer
@onready var image_rect: TextureRect = $Container/ImageRect

func _on_new_answer_button_pressed() -> void:
	if answers_container.get_child_count() > 8: return
	
	var new_answer_input := ANSWER_INPUT.instantiate()
	question.answers.append(new_answer_input.text)
	answers_container.add_child(new_answer_input)
	new_answer_input.answer_checked.connect(_on_answer_checked, 2)
	new_answer_input.answer_changed.connect(_on_answer_changed, 1)

func _on_answer_checked(idx: int, check: bool) -> void:
	if check:
		question.correct = idx
		for j in range(answers_container.get_child_count()):
			answers_container.get_child(j).check.button_pressed = idx == j
	else:
		answers_container.get_child(0).check.button_pressed = true

func _on_question_input_text_changed(new_text: String) -> void:
	question.question = new_text

func _on_answer_changed(new_text: String, idx: int) -> void:
	question.answers[idx] = new_text

func _on_upload_button_loaded(file_name: String, file_type: String, base64_data: String) -> void:
	question.img_data = base64_data
	print(question.img_data)
	question.img_type = file_type.replace("image/", "")
	var data = Marshalls.base64_to_raw(base64_data)
	var image = Image.new()
	match question.img_type:
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
