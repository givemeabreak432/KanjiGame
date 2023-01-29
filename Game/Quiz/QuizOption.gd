extends Node
#QuizOption could better ben amed "kanji button"
#this is called whenever a kanji needs to act as a button
#thus far, this is used only in Quiz and KanjiScroller
#holdable dictates the type of button. If a button is holdable it has some extra functions.

var kanji_id
var holdable = false #if this is off, button cannot be held down. Hold function is used for non-quiz button
var is_held = false 
var selected = false
var held_length = 0

signal button_hit
signal button_held
signal button_released

func _ready():
	pass
	
func _init():
	pass
	
func _process(_i):
	if is_held:
		held_length += 1
	if held_length == 60 and not selected: #button is held for 1.5 seconds
		emit_signal("button_held", kanji_id)
		self.theme = load("res://Assets/HeldButton.tres") 
		held_length = 0
		selected = true
		is_held = false

#takes 2 parameters - a kanji id and a boolean
#if boolean is true, kanji ID is correct answer and sets kanji to right answer
#if boolean is false, kanji ID is wrong answer and will set kanji to random answer other than correct answer
func set_kanji(kanji, correct):
	kanji_id = kanji
	if not correct:
		while kanji == kanji_id:
			kanji_id = randi() % JapaneseDictionary.size()
	
	#find kanji
	if(QuizSettings.quiz_type == 0):
		self.text = JapaneseDictionary.get_kanji(kanji_id).get_kanji()
	if(QuizSettings.quiz_type == 1):
		self.text = JapaneseDictionary.get_kanji(kanji_id).get_meaning(true, ", ", 1)

func release_button():
	selected = false
	self.theme = load("res://Assets/InvisibleButton.tres") 
	emit_signal("button_released", kanji_id)


func _on_QuizOption_pressed():
	if not selected:
		emit_signal("button_hit", kanji_id)


func _on_QuizOption_button_down():
	if holdable:
		is_held = true
	#calls "releases_button" after a  delay to de-select button
	#delay is to prevent simultaneous pressed() signal from emitting "button_hit"
	if selected: 
		get_tree().create_timer(.1).connect("timeout", self, "release_button") 

func _on_QuizOption_button_up():
	if holdable:
		is_held = false
