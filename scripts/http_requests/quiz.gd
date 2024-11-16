extends HTTPRequest
class_name QuizRequest

var res: Dictionary
var image_request: ImageRequest

func _ready() -> void:
	image_request = ImageRequest.new()
	add_child(image_request)
	
	request_completed.connect(_on_request_completed, 4)

func save_quiz(quiz: Quiz) -> String:
	print(quiz.questions[0].img_data)
	for i in range(quiz.questions.size()):
		var question = quiz.questions[i]
		if question.img_data:
			print(i)
			var img_request = ImageRequest.new()
			add_child(img_request)
			question.img_url = await img_request.upload_image(question.img_data, question.img_type, "quiz")
			img_request.queue_free()
	
	var img_request = ImageRequest.new()
	add_child(img_request)
	quiz.img_url = await img_request.upload_image(quiz.img_data, quiz.img_type, "quiz")
	
	var body = JSON.new().stringify(Quiz.to_dictionary(quiz))
	
	request("http://%s/games/quiz/save_quiz.php" % OS.get_environment("host"), ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	await request_completed
	
	return res.message if res.has("message") else "Fail"

func get_quizes() -> Array[QuizInfo]:
	var body = JSON.new().stringify({"id": User.id if User.id else null})

	request("http://%s/games/quiz/get_quizes.php" % OS.get_environment("host"), ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	await request_completed

	var quizes_dic = res.quizes if res.has("quizes") else []

	var quizes: Array[QuizInfo] = []

	for quiz_dic in quizes_dic:
		var new_quiz := QuizInfo.new()
		new_quiz.id = quiz_dic.id
		new_quiz.name = quiz_dic.name
		new_quiz.theme = quiz_dic.theme
		new_quiz.img_url = quiz_dic.img_url
		new_quiz.question_count = quiz_dic.question_count
		new_quiz.best_score = quiz_dic.best_score
		quizes.append(new_quiz)
	
	return quizes

func get_quiz(id: int) -> Quiz:
	var body = JSON.new().stringify({"id": id})

	request("http://%s/games/quiz/get_quiz.php" % OS.get_environment("host"), ["Content-Type: application/json"], HTTPClient.METHOD_POST, body)
	await request_completed

	var quiz_dic = res.quiz if res.has("quiz") else null
	if !quiz_dic: return null

	return Quiz.from_dictionary(quiz_dic)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	res = response if response else {}
