extends HTTPRequest
class_name ImageRequest

var res_texture: ImageTexture
var res: Dictionary

var texture_rect: TextureRect

signal texture_parsed

func _ready() -> void:
	texture_rect = TextureRect.new()
	add_child(texture_rect)
	texture_rect.visible = false
	
	request_completed.connect(_on_request_completed, 4)

func get_image(url: String):
	print(url)
	request(url)
	await request_completed	
	return texture_rect.texture.duplicate() if texture_rect.texture else null

func upload_image(file_b64: String, file_type: String, output_dir: String, file_name: String = "") -> String:
	var body = JSON.new().stringify({
		"image": "data:image/%s;base64,%s" % [file_type, file_b64],
		"output_dir": output_dir,
		"file_name": file_name
	})
	
	request("http://%s/games/quiz/upload_image.php" % OS.get_environment("host"), [], HTTPClient.METHOD_POST, body)
	await request_completed
	
	return res.file_path if res.has("file_path") else null

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var content_type_arr = Array(headers).filter(func(h): return h.to_lower().contains("content-type:"))
	var content_type: String = content_type_arr[0] if content_type_arr.size() else ""
	var is_img = content_type.contains("image")
	if is_img:
		if result != HTTPRequest.RESULT_SUCCESS:
			push_error("Image couldn't be downloaded. Try a different image.")
		var image = Image.new()
		var extension = content_type.replace("/", ".").get_extension()
		
		var error
		
		match extension:
			"png":
				error = image.load_png_from_buffer(body)
			"jpg", "jpeg":
				error = image.load_jpg_from_buffer(body)
			"webp":
				error = image.load_webp_from_buffer(body)
			"svg":
				error = image.load_svg_from_buffer(body)
			_:
				push_error("Invalid image format.")
		
		if error != OK:
			push_error("Couldn't load the image.")
		
		var res_texture = ImageTexture.create_from_image(image)
		texture_rect.texture = res_texture
		return
	
	if content_type.contains("json"):
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		var response = json.get_data()
		
		res = response if response else {}
