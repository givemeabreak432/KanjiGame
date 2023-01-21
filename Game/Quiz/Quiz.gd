extends Control

const QuizOption = preload("res://Game/Quiz/QuizOption.tscn") # Relative path


onready var quiz_options_box = $VBoxContainer/QuizOptionsBox
onready var quiz_item = $VBoxContainer/QuizItem
onready var correct_label = $VBoxContainer/Correct
onready var next_question = $VBoxContainer/HBoxContainer/NextQuestion
onready var restart_quiz = $VBoxContainer/HBoxContainer/RestartButton

#quiz stats
onready var score = 0
onready var correct_kanji #holds the current kanji_ID
onready var current_question #holds the number of questions answered thus far
onready var correct_option #holds the current current option button index

func _ready():
	current_question = 0
	create_question()

#creates a quesstion based on list selectied on QuizSettings
func create_question():
	
	#select kanji and option to be correct
	correct_kanji = QuizSettings.quiz_list[randi() % QuizSettings.quiz_list.size()]
	correct_option = randi() % QuizSettings.number_of_options
	
	#remove remove any old answer buttons
	for i in quiz_options_box.get_children():
		quiz_options_box.remove_child(i)
		i.queue_free()
		
	#create answer buttons and connect to answer_question function
	for i in QuizSettings.number_of_options:
		var option = QuizOption.instance()
		if i == correct_option: option.set_kanji(correct_kanji, true)
		else: option.set_kanji(correct_kanji, false)
		quiz_options_box.add_child(option)
		quiz_options_box.get_child(i).connect("button_hit", self, "answer_question")
	
	draw_question()
	
#draws the current question based on quiz type.
func draw_question():
	var question_text = ""
	#draws kanji info
	if(QuizSettings.quiz_type == 0):
		question_text = JapaneseDictionary.get_kanji(correct_kanji).get_meaning(true, ", ", 2) + '\n'
		question_text += JapaneseDictionary.get_kanji(correct_kanji).get_on_yomi(true, ", ") + "\n"
		question_text += JapaneseDictionary.get_kanji(correct_kanji).get_kun_yomi(true, ", ")
	if(QuizSettings.quiz_type == 1):
		question_text = JapaneseDictionary.get_kanji(correct_kanji).get_kanji()
		
	quiz_item.text = question_text


#hides all incorrect answers, shows next question button.
func answer_question(kanji_id):
	if kanji_id == correct_kanji:
		correct_label.text = "Correct"
		score += 1
	else: correct_label.text = "Incorrect"
	correct_label.visible = true
	
	#hides all but correct button, on the correct button disconnects the signal to prevent spamming button.
	var j = 0
	for i in quiz_options_box.get_children():
		if j != correct_option:
			quiz_options_box.remove_child(i)
			i.queue_free()
		else:
			i.disconnect("button_hit", self, "answer_question")
			i.set_h_size_flags(SIZE_EXPAND + SIZE_SHRINK_CENTER)
		j+=1
			
	current_question += 1
	next_question.visible = true

#loads next question after buttons pressed, making sure to disconnect any previous answers
#if all questions have been answered, ends the quiz.
func _on_NextQuestion_pressed():
	next_question.visible = false
	correct_label.visible = false
	if(current_question < QuizSettings.quiz_length):
		for i in quiz_options_box.get_children():
			quiz_options_box.remove_child(i)
			i.queue_free()
		create_question()
	else:
		restart_quiz.visible = true
		quiz_item.text = "Quiz Ended \n Final Score: \n" + str(score)
		for i in quiz_options_box.get_children():
			quiz_options_box.remove_child(i)
			i.queue_free()


func _on_RestartButton_pressed():
	get_tree().change_scene("res://Game/Quiz/QuizLoader.tscn")
