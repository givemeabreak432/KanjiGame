extends Control

const QuizOption = preload("res://Game/Quiz/QuizOption.tscn") # Relative path


onready var quiz_options_box = $VBoxContainer/QuizOptionsBox
onready var quiz_item = $VBoxContainer/QuizItem
onready var correct_label = $VBoxContainer/Correct

#quiz settings - these define the quiz
onready var random_number
onready var number_of_options = 5

#quiz stats
onready var score = 0
onready var correct_kanji

func _ready():
	create_question()

#creates a quesstion based on list selectied on QuizSettings
func create_question():
	
	#select kanji and option to be correct
	correct_kanji = randi() % QuizSettings.quiz_list.size()
	var correct_option = randi() % number_of_options
	
	#remove remove any old answer buttons
	for i in quiz_options_box.get_children():
		quiz_options_box.remove_child(i)
		i.queue_free()
		
	#create answer buttons and connect to answer_question function
	for i in number_of_options:
		var option = QuizOption.instance()
		if i == correct_option: option.set_kanji(correct_kanji, true)
		else: option.set_kanji(correct_kanji, false)
		quiz_options_box.add_child(option)
		quiz_options_box.get_child(i).connect("button_hit", self, "answer_question")
		
	
	quiz_item.text = JapaneseDictionary.get_kanji(correct_kanji).get_kanji()

func answer_question(kanji_id):
	print("kanji_id " + str(kanji_id))
	print("correct_kanji " + str(correct_kanji))
	if kanji_id == correct_kanji:
		score += 1
		correct_label.text = "Score: " + str(score)
	create_question()

