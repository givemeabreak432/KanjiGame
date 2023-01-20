#Quizloader menu allows player to customize quiz settings. 
#ListSelection - For selecting which list to Quiz from
#OptionButton - For selecting what kind of quiz. 
#LengthButton - selecting legnth of quiz. Dropdown is innefficient, should make into "number line" esque object.
#More to come...

extends Node

onready var list_selector = $Container/Options/Options/ListSelection
onready var length_number = $Container/Options/Options/Length/LengthNumber

var length_scaler = 0
var length_time = 0
var button_pressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for each in List.get_list_keys():
		list_selector.add_item(each)
	pass 
	
	length_number.text = str(JapaneseDictionary.size())
	
func _process(i):
	if button_pressed:
		update_length()
		length_time += 1
	else:
		length_time = 0

#updates length based on scaler, and length of time buttons have been held down
func update_length():
	var old_length = int(length_number.text)
	if length_time % 10 == 0 and length_time != 0:
		if(length_time % 100 == 0):
			length_scaler = length_scaler*2
		
		var new_length = old_length + length_scaler
		
		if new_length > JapaneseDictionary.size():
			length_number.text = str(JapaneseDictionary.size())
		elif new_length <= JapaneseDictionary.size() and new_length >= 1:
			length_number.text = str(new_length)
		elif new_length < 1:
			length_number.text = str(1)
	
func _on_Begin_pressed():
	QuizSettings.quiz_list = List.get_list_values(list_selector.text)
	QuizSettings.quiz_length = int(length_number.text)
	get_tree().change_scene("res://Game/Quiz/Quiz.tscn")
	pass 

func _on_DecreaseButton_button_down():
	button_pressed = true
	length_scaler = -1




func _on_IncreaseButton_button_down():
	button_pressed = true
	length_scaler = 1


func _on_DecreaseButton_button_up():
	button_pressed = false
	length_scaler = 0


func _on_IncreaseButton_button_up():
	button_pressed = true
	length_scaler = 0
