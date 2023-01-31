extends Control
#kanji scroller is a list of all kanji dispalyed by kanji
#selecting a kanji will take you to kanji-info screen for selected kanji
#reuses QuizOption scene for buttons - may need to make custom scene later.

const QuizOption = preload("res://Game/Quiz/QuizOption.tscn")
const KanjiInfo = preload("res://Game/Menus/KanjiInfo.tscn") 

var kanji_page
var current_list = []
var held_kanji = []
var starting_buttons = 16*4  #by default, it should load the first 16 rows of 4 buttons

onready var column1 = $VBox/Scroller/ScrollMargins/Row/Column1
onready var column2 = $VBox/Scroller/ScrollMargins/Row/Column2
onready var column3 = $VBox/Scroller/ScrollMargins/Row/Column3
onready var column4 = $VBox/Scroller/ScrollMargins/Row/Column4
onready var list_selector = $VBox/NavigationContainer/ListSelector
onready var list_kanji_adder = $VBox/NavigationContainer/ListAddKanji
onready var scroll_box = $VBox/Scroller
onready var VBox = $VBox

signal kanji_added


func _ready():
	load_buttons(starting_buttons)
	list_selector.connect("select_list", self, "load_list")
	list_kanji_adder.connect("list_add_kanji", self, "add_held_kanji")

func _process(delta):
	if get_tree().get_nodes_in_group("buttons").size() < current_list.size():
		create_button(get_tree().get_nodes_in_group("buttons").size())
	pass
	

func load_buttons(number_of_buttons = current_list.size()):
	if current_list.size() == 0:
		current_list = range(JapaneseDictionary.size())
		
	for i in number_of_buttons:
		if i >= current_list.size():
			break
		create_button(i)

func create_button(kanji_id):
	var button = QuizOption.instance()
	button.set_kanji(current_list[kanji_id], true)
	button.holdable=true
	match kanji_id%4:
		0:column1.add_child(button)
		1:column2.add_child(button)
		2:column3.add_child(button)
		3:column4.add_child(button)
	button.connect("button_hit", self, "kanji_selected")
	button.connect("button_held", self, "kanji_held")
	button.connect("button_released", self, "kanji_released")
	button.add_to_group("buttons")
	
func unload_buttons():
	held_kanji.clear() 
	for each in column1.get_children() + column2.get_children() + column3.get_children() + column4.get_children():
		remove_child(each)
		each.queue_free()

#displays kanji info screen
func kanji_selected(kanji_id):
	kanji_page = KanjiInfo.instance()
	VBox.visible = false
	add_child(kanji_page)
	kanji_page.load_page(kanji_id)
	kanji_page.connect("close_screen", self, "close_kanji_screen")

func close_kanji_screen():
	remove_child(kanji_page)
	kanji_page.queue_free()
	VBox.visible = true


func _on_SearchBar_text_entered(text):
	current_list = JapaneseDictionary.search(text)
	unload_buttons()
	load_buttons()


func _on_BackButton_pressed():
	get_tree().change_scene("res://Game/Menus/TitleScreen.tscn")

#shows radicals - kanji with only one radical
func _on_RadicalButton_pressed():
	current_list = JapaneseDictionary.get_radicals()
	unload_buttons()
	load_buttons()

#loads a specifically selected list
#called automatically from list_selector
func load_list(list_name):
	current_list = List.get_list_values(list_name)
	unload_buttons()
	load_buttons()

#if the button is held down, adds kanji to list
func kanji_held(kanji_id):
	held_kanji.append(kanji_id)

#removese kanji from list upon release of button
func kanji_released(kanji_id):
	held_kanji.erase(kanji_id)

func add_held_kanji(list):
	List.add_many_kanji(list, held_kanji)
	get_tree().call_group("buttons", "release_button")
