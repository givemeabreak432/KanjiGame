#Quizloader menu allows player to customize quiz settings. 
#ListSelection - For selecting which list to Quiz from
#OptionButton - For selecting what kind of quiz. 
#LengthButton - selecting legnth of quiz. Dropdown is innefficient, should make into "number line" esque object.
#More to come...

extends Node

onready var list_selector = $Container/Options/Options/ListSelection

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for each in List.get_list_keys():
		list_selector.add_item(each)
	pass 


func _on_Begin_pressed():
	QuizSettings.quiz_list = List.get_list_values(list_selector.text)
	get_tree().change_scene("res://Game/Quiz/Quiz.tscn")
	pass 
