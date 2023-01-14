extends Container

#loading kanji class
const KanjiScript = preload("Kanji.gd") # Relative path
onready var current_kanji

#global var
var current_page = 0
var current_list = []
var current_list_name = ""

#node linked var
onready var kanji_label = $InfoContainer/KanjiTitle/KanjiLabel
onready var on_yomi = $InfoContainer/KanjiInfo/OnYomi #line 6
onready var kun_yomi = $InfoContainer/KanjiInfo/KunYomi # line 7
onready var meaning = $InfoContainer/KanjiInfo/Meaning # line 5


# Called when the node enters the scene tree for the first time.
func _ready():
	load_list()
	#connect signals
	get_parent().connect("select_list", self, "load_list")
	get_parent().connect("list_add_kanji", self, "add_to_list")
	
	#this seems like bad practice. current requires nested nodes to load.
	get_parent().get_parent().connect("change_kanji", self, "load_entry")
	List.connect("list_created", self, "_reload_directories")
	pass # Replace with function body.

#load the currently selected list. If non selected, defaults to full dictionary
#takes a list nam as argument
func load_list(list = null):
	current_page = 0 #set page to 0 when loading new list.
	current_list = List.get_list_values(list)
	if List.is_empty(list): current_list_name = null
	else: current_list_name = list
	#this seems like bad practice.
	load_entry(current_page)

#pull kanji from current_list[curreent_kanji] 
func load_entry(entry):
	current_kanji = JapaneseDictionary.get_kanji(current_list[entry])
	
	kanji_label.text = current_kanji.get_kanji()
	on_yomi.text = current_kanji.get_on_yomi(true, ", ")
	kun_yomi.text = current_kanji.get_kun_yomi(true, ", ")
	meaning.text = current_kanji.get_meaning(true, ", ")

