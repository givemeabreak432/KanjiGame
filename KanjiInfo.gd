extends MarginContainer

#loading kanji class
const KanjiScript = preload("Kanji.gd") # Relative path
onready var current_kanji

#global var
var current_page = 0
var current_list = ""
var current_list_keys = []

#node linked var
onready var kanji_label = $VBoxContainer/InfoContainer/KanjiTitle/KanjiLabel
onready var on_yomi = $VBoxContainer/InfoContainer/KanjiInfo/OnYomi #line 6
onready var kun_yomi = $VBoxContainer/InfoContainer/KanjiInfo/KunYomi # line 7
onready var meaning = $VBoxContainer/InfoContainer/KanjiInfo/Meaning # line 5
onready var page = $VBoxContainer/NavigationContainer/Page # page counter
onready var list_selector = $VBoxContainer/NavigationContainer/ListSelector
onready var list_adder = $VBoxContainer/NavigationContainer/ListAddKanji


# Called when the node enters the scene tree for the first time.
func _ready():
	load_list()
	#connect signals
	list_selector.connect("select_list", self, "load_list")
	list_adder.connect("list_add_kanji", self, "add_to_list")
	pass # Replace with function body.

#load the currently selected list. If non selected, defaults to full dictionary
#takes a list nam as argument
func load_list(list = null):
	current_page = 0 #set page to 0 when loading new list.
	current_list = List.get_list_values(list)
	load_entry(current_page)
	pass

#pull kanji from current_list[curreent_kanji] 
func load_entry(entry):
	current_kanji = JapaneseDictionary.get_kanji(current_list[current_page])
	
	kanji_label.text = current_kanji.get_kanji()
	on_yomi.text = current_kanji.get_on_yomi(true, ", ")
	kun_yomi.text = current_kanji.get_kun_yomi(true, ", ")
	meaning.text = current_kanji.get_meaning(true, ", ")
	page.text = str(entry + 1) + "/" + str(current_list.size())

#SIGNAL functions
#These functions run when a signal happens

#adds currently displayed kanji to list.
func add_to_list(entry):
	List.add_kanji_to_list(entry, current_list[current_page])
	pass


#navigate to previous kanji page
func _on_LeftButton_pressed():
	current_page = current_page - 1
	if current_page < 0:
		current_page = current_list.size() - 1		
	load_entry(current_page)
	pass # Replace with function body.

#navigate to next kanji page
func _on_RightButton_pressed():
	current_page = current_page + 1
	if current_page == current_list.size():
		current_page = 0
	load_entry(current_page)
	pass # Replace with function body.


func _on_BackButton_pressed():
	get_tree().change_scene("res://TitleScreen.tscn")
	pass # Replace with function body.
