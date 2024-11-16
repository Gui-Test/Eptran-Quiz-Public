@tool
extends Resource
class_name Question

@export var question: String
@export var answers: Array :
	set(value):
		if Engine.is_editor_hint():
			if answers.size() < 2:
				answers = ["", ""]
			assert(value.size() >= 2, "Minimum of answers is 2.")
			assert(value.size() <= 8, "Maximum of answers is 8.")
			if correct >= value.size():
				correct -= 1
			answers = value
		else:
			answers = value
@export_range(0, 7) var correct: int :
	set(value):
		if Engine.is_editor_hint():
			assert(value < answers.size(), "Answer doesn't exists on answers array.")
			correct = value
		else:
			correct = value

@export_file var img_url: String = ""
var img_data: String
var img_type: String
