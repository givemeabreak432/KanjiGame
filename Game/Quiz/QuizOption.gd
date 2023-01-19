extends Node

#loading kanji class
var kanji_id
signal button_hit

func _ready():
	pass # Replace with function body.

func _init():
	pass
	
#takes 2 parameters - a kanji id and a boolean
#if boolean is true, kanji ID is correct answer and sets kanji to right answer
#if boolean is false, kanji ID is wrong answer and will set kanji to random answer other than correct answer
func set_kanji(kanji, correct):
	kanji_id = kanji
	if not correct:
		while kanji == kanji_id:
			kanji_id = randi() % JapaneseDictionary.size()
	
	self.text = JapaneseDictionary.get_kanji(kanji_id).get_kanji()
	
	pass

func _on_QuizOption_pressed():
	emit_signal("button_hit", kanji_id)
	pass # Replace with function body.
