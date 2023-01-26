extends Container

#display is only for displaying kanji. It holds the current kanji, but no other information

#loading kanji class
const KanjiScript = preload("res://Game/Project/Kanji.gd") # Relative path
onready var current_kanji

#node linked var
onready var kanji_label = $InfoContainer/KanjiTitle/KanjiLabel
onready var quizes_label = $InfoContainer/KanjiInfo/TotalQuizes #line 6
onready var answers_label = $InfoContainer/KanjiInfo/CorrectAnswers # line 7
onready var percentage_label = $InfoContainer/KanjiInfo/Percentage # line 5


# Called when the node enters the scene tree for the first time.
func _ready():
	load_entry(0)
	#this seems like bad practice. current requires nested nodes to load.
	get_parent().get_parent().connect("change_kanji", self, "load_entry")
	List.connect("list_created", self, "_reload_directories")
	pass # Replace with function body.


#pull kanji from current_list[curreent_kanji] 
func load_entry(entry):
	current_kanji = JapaneseDictionary.get_kanji(entry)
	var quizes = JapaneseDictionary.get_quizes(entry)
	var answers = JapaneseDictionary.get_answers(entry)
	var percent
	if quizes != 0:
		
		percent = round(((float(answers)/float(quizes))*100))
	else:
		percent = 0
	kanji_label.text = current_kanji.get_kanji()
	quizes_label.text = "Total Quizes: " + str(quizes)
	answers_label.text = "Answered Correctly: "  + str(answers)
	percentage_label.text = "Score: " + str(percent) + "%"

