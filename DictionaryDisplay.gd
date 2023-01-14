extends Container

#display is only for displaying kanji. It holds the current kanji, but no other information

#loading kanji class
const KanjiScript = preload("Kanji.gd") # Relative path
onready var current_kanji

#node linked var
onready var kanji_label = $InfoContainer/KanjiTitle/KanjiLabel
onready var on_yomi = $InfoContainer/KanjiInfo/OnYomi #line 6
onready var kun_yomi = $InfoContainer/KanjiInfo/KunYomi # line 7
onready var meaning = $InfoContainer/KanjiInfo/Meaning # line 5


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
	
	kanji_label.text = current_kanji.get_kanji()
	on_yomi.text = current_kanji.get_on_yomi(true, ", ")
	kun_yomi.text = current_kanji.get_kun_yomi(true, ", ")
	meaning.text = current_kanji.get_meaning(true, ", ")

