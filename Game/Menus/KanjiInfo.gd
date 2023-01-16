extends MarginContainer

#loading kanji class
const KanjiScript = preload("res://Game/Project/Kanji.gd") # Relative path
onready var current_kanji

#global var
var current_page = 0
var current_list = []
var current_list_name = ""

signal change_kanji
#node linked var

onready var page = $VBoxContainer/NavigationContainer/Page # page counter
onready var list_selector = $VBoxContainer/NavigationContainer/ListSelector
onready var list_adder = $VBoxContainer/NavigationContainer/ListAddKanji
onready var remove_kanji_popup = $VBoxContainer/NavigationContainer/RemoveKanji/RemoveKanjiPopup
onready var dictionary_display = $VBoxContainer/DictionaryDisplay
onready var flash_card_display = $VBoxContainer/FlashCardDisplay

# Called when the node enters the scene tree for the first time.
func _ready():
	load_list()
	#connect signals
	list_selector.connect("select_list", self, "load_list")
	list_adder.connect("list_add_kanji", self, "add_to_list")
	List.connect("list_created", self, "_reload_directories")
	pass # Replace with function body.

#load list updates current list to selected list. If nothing is passed in, defaults to dictionary
#additionally, when load list is called, setes page number to 0 (and updates text)
#updates current_list_name if current_list is not null
#finally emits a signal to update displayed kanji.
#takes 2 parameters: The list, and whether list was searched.
func load_list(list = null, searched = false):
	current_page = 0 #set page to 0 when loading new list.
	if not searched:
		current_list = List.get_list_values(list)
		page.text = str(current_page + 1) + "/" + str(current_list.size())
		if List.is_empty(list): current_list_name = null
		else: current_list_name = list
	else:
		current_list = list
		page.text = str(current_page + 1) + "/" + str(current_list.size())
	emit_signal("change_kanji", current_list[current_page])

#*********************************#
#SIGNAL functions
#These functions run when a signal happens

#adds currently displayed kanji to list.
func add_to_list(list):
	List.add_kanji_to_list(list, current_list[current_page])

func _reload_directories():
	print("reload!")
	list_selector.reload_directory()
	list_adder.reload_directory()

#navigate to previous kanji page
func _on_LeftButton_pressed():
	current_page = current_page - 1
	if current_page < 0:
		current_page = current_list.size() - 1		
	page.text = str(current_page + 1) + "/" + str(current_list.size())
	emit_signal("change_kanji", current_list[current_page])

#navigate to next kanji page
func _on_RightButton_pressed():
	current_page = current_page + 1
	if current_page == current_list.size():
		current_page = 0
	page.text = str(current_page + 1) + "/" + str(current_list.size())
	emit_signal("change_kanji", current_list[current_page])


func _on_BackButton_pressed():
	get_tree().change_scene("res://Game/Menus/TitleScreen.tscn")


func _on_RemoveKanji_pressed():
	if current_list_name != null:
		List.remove_kanji_from_list(current_list_name, current_list[current_page])
		remove_kanji_popup.dialog_text = "Kanji Removed!"
		remove_kanji_popup.popup()
		load_list(current_list_name)
	else:
		remove_kanji_popup.dialog_text = "Cannot remove kanji from dictionary."
		remove_kanji_popup.popup()

#changes display mode
func _on_DisplayMode_item_selected(index):
	if index == 0:
		dictionary_display.visible = true
		flash_card_display.visible = false
	if index == 1:
		dictionary_display.visible = false
		flash_card_display.visible = true
		

#search function. Should create a custom list that hits all searches. 
#Should search onyomi, kunyomi, meanings
func _on_Search_text_entered(new_text):
	load_list(JapaneseDictionary.search(new_text), true)
	pass # Replace with function body.
