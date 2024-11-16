extends Control


func _on_file_dialog_file_selected(path: String) -> void:
	var image = Image.new()
	image.load(path)
	var texture = ImageTexture.create_from_image(image)
	$TextureRect.texture = texture
	await $ImageRequest.upload_image(path, "quiz")
