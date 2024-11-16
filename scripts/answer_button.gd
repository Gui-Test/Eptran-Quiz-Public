extends Button
class_name AnswerButton

signal answer_pressed(answer: int)

var colors = [Color.LAWN_GREEN, Color.ROYAL_BLUE, Color.ORANGE_RED, Color.YELLOW, Color.LAWN_GREEN, Color.ROYAL_BLUE, Color.ORANGE_RED, Color.YELLOW]

func _ready() -> void:
	theme["Button/styles/normal"].bg_color = colors[get_index()]
	theme["Button/styles/hover"].bg_color = colors[get_index()]

func _on_pressed() -> void:
	answer_pressed.emit(get_index())
