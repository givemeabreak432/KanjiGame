extends MarginContainer


func _ready():
	randomize()
	pass




func _on_Dictionairy_pressed():
	get_tree().change_scene("res://Game/Menus/KanjiInfo.tscn")


func _on_Favorites_pressed():
	get_tree().change_scene("res://Game/Quiz/QuizLoader.tscn")
