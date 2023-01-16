extends Control

const QuizOption = preload("res://Game/Quiz/QuizOption.tscn") # Relative path

onready var quiz_options_box = $VBoxContainer/QuizOptionsBox

func _ready():
	for i in 100:
		var option = QuizOption.instance()
		option.text = "Option " + str(i)
		quiz_options_box.add_child(option) 
