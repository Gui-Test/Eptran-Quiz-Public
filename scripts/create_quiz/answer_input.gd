extends LineEdit

@onready var check: CheckButton = $CheckButton

signal answer_checked(idx: int, check: bool)
signal answer_changed(new_text: String, idx: int)

func _ready() -> void:
	check.button_pressed = !get_index()

func _on_check_button_pressed() -> void:
	answer_checked.emit(get_index(), check.button_pressed)

func _on_text_changed(new_text: String) -> void:
	answer_changed.emit(new_text, get_index())
