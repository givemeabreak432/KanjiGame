extends MarginContainer

#class variable for list - loading list script. 
const ListScript = preload("List.gd") # Relative path
onready var current_list

#loading kanji class
const KanjiScript = preload("Kanji.gd") # Relative path
onready var current_kanji

#global var
var current_page = 0
#node linked var
onready var kanji_label = $VBoxContainer/InfoContainer/KanjiTitle/KanjiLabel
onready var on_yomi = $VBoxContainer/InfoContainer/KanjiInfo/OnYomi #line 6
onready var kun_yomi = $VBoxContainer/InfoContainer/KanjiInfo/KunYomi # line 7
onready var meaning = $VBoxContainer/InfoContainer/KanjiInfo/Meaning # line 5
onready var page = $VBoxContainer/NavigationContainer/Page # page counter
onready var list_selector = $VBoxContainer/NavigationContainer/ListSelector


# Called when the node enters the scene tree for the first time.
func _ready():
	load_list()
	
	#connect signals
	list_selector.connect("select_list", self, "load_list")
	pass # Replace with function body.

#load current list. If nothing passed in will load default list.
func load_list(list = null):
	print(list)
	current_list = ListScript.new()
	if list != null:
		current_list.load_dict(list)
	else:
		current_list.load_dict()
		
	load_entry(current_page)
	pass

#reloads current page dsiplayed with entry #
func load_entry(entry):
	current_kanji = current_list.return_entry(entry)
	
	kanji_label.text = current_kanji.get_kanji()
	on_yomi.text = current_kanji.get_on_yomi(true, ", ")
	kun_yomi.text = current_kanji.get_kun_yomi(true, ", ")
	meaning.text = current_kanji.get_meaning(true, ", ")
	page.text = str(entry + 1) + "/" + str(current_list.size())

func add_to_list(entry, list):
	pass



#BUTTON FUNCTIONS
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
