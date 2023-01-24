extends Control

onready var label = $HBoxContainer/Label

func _ready():
	pass # Replace with function body.




func _on_LineEdit_text_entered(new_text):
	label.text = JapaneseDictionary.translate_romaji(new_text)
	pass # Replace with function body.
