extends Resource
class_name Quiz

@export var name: String
@export var theme: String
@export_file var img_url: String

@export var questions: Array[Question] :
	set(value):
		questions = value
var img_data: String
var img_type: String

static func from_dictionary(dic: Dictionary) -> Quiz:
	var quiz = Quiz.new()
	quiz.name = dic.name
	quiz.theme = dic.theme
	quiz.img_url = dic.img_url
	var questions: Array[Question]
	
	for question_dic in dic.questions:
		var question = Question.new()
		question.question = question_dic.question
		question.correct = question_dic.correct
		question.answers = question_dic.answers
		
		if question_dic.img_url:
			question.img_url = question_dic.img_url
		
		questions.append(question)
	
	quiz.questions = questions
	
	return quiz

static func to_dictionary(quiz: Quiz) -> Dictionary:
	var dic: Dictionary = {
		"name": quiz.name,
		"theme": quiz.theme,
		"img_url": quiz.img_url,
		"questions": quiz.questions.map(func(question: Question):
			return {
				"question": question.question,
				"correct": question.correct,
				"img_url": question.img_url if question.img_url else null,
				"answers": question.answers
				}
			)
		}
	
	return dic
