extends Button

var file_access_web: FileAccessWeb

signal loaded(file_name: String, file_type: String, base64_data: String)

func _ready() -> void:
	pressed.connect(_on_pressed)
	file_access_web = FileAccessWeb.new()
	file_access_web.loaded.connect(_on_loaded, 3)

func _on_pressed() -> void:
	file_access_web.open(".png, .jpeg, .jpg, .svg, .webp")

func _on_loaded(file_name: String, file_type: String, base64_data: String) -> void:
	loaded.emit(file_name, file_type, base64_data)
