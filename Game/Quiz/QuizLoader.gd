#Quizloader menu allows player to customize quiz settings. 
#ListSelection - For selecting which list to Quiz from
#OptionButton - For selecting what kind of quiz. 
#More to come...

extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Begin_pressed():
	get_tree().change_scene("res://Game/Quiz/Quiz.tscn")
	pass # Replace with function body.
