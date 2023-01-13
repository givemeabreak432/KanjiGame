extends MarginContainer

#loading kanji class
const KanjiScript = preload("Kanji.gd") # Relative path
onready var current_kanji

#global var
var current_page = 0
var current_list = []
var current_list_name = ""

#node linked var
onready var kanji_label = $VBoxContainer/DictionaryDisplay/InfoContainer/KanjiTitle/KanjiLabel
onready var on_yomi = $VBoxContainer/DictionaryDisplay/InfoContainer/KanjiInfo/OnYomi #line 6
onready var kun_yomi = $VBoxContainer/DictionaryDisplay/InfoContainer/KanjiInfo/KunYomi # line 7
onready var meaning = $VBoxContainer/DictionaryDisplay/InfoContainer/KanjiInfo/Meaning # line 5
onready var page = $VBoxContainer/NavigationContainer/Page # page counter
onready var list_selector = $VBoxContainer/NavigationContainer/ListSelector
onready var list_adder = $VBoxContainer/NavigationContainer/ListAddKanji
onready var remove_kanji_popup = $VBoxContainer/NavigationContainer/RemoveKanji/RemoveKanjiPopup

# Called when the node enters the scene tree for the first time.
func _ready():
	load_list()
	#connect signals
	list_selector.connect("select_list", self, "load_list")
	list_adder.connect("list_add_kanji", self, "add_to_list")
	List.connect("list_created", self, "_reload_directories")
	pass # Replace with function body.

#load the currently selected list. If non selected, defaults to full dictionary
#takes a list nam as argument
func load_list(list = null):
	current_page = 0 #set page to 0 when loading new list.
	current_list = List.get_list_values(list)
	if List.is_empty(list): current_list_name = null
	else: current_list_name = list
	
	load_entry(current_page)

#pull kanji from current_list[curreent_kanji] 
func load_entry(entry):
	current_kanji = JapaneseDictionary.get_kanji(current_list[current_page])
	
	kanji_label.text = current_kanji.get_kanji()
	on_yomi.text = current_kanji.get_on_yomi(true, ", ")
	kun_yomi.text = current_kanji.get_kun_yomi(true, ", ")
	meaning.text = current_kanji.get_meaning(true, ", ")
	page.text = str(entry + 1) + "/" + str(current_list.size())



#*********************************#
#SIGNAL functions
#These functions run when a signal happens

#adds currently displayed kanji to list.
func add_to_list(list):
	List.add_kanji_to_list(list, current_list[current_page])
	pass

func _reload_directories():
	print("reload!")
	list_selector.reload_directory()
	list_adder.reload_directory()
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
	


func _on_BackButton_pressed():
	get_tree().change_scene("res://TitleScreen.tscn")


func _on_RemoveKanji_pressed():
	if current_list_name != null:
		List.remove_kanji_from_list(current_list_name, current_list[current_page])
		remove_kanji_popup.dialog_text = "Kanji Removed!"
		remove_kanji_popup.popup()
		load_list(current_list_name)
	else:
		remove_kanji_popup.dialog_text = "Cannot remove kanji from dictionary."
		remove_kanji_popup.popup()
