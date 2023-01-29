extends Control
#kanji scroller is a list of all kanji dispalyed by kanji
#selecting a kanji will take you to kanji-info screen for selected kanji
#reuses QuizOption scene for buttons - may need to make custom scene later.

const QuizOption = preload("res://Game/Quiz/QuizOption.tscn")
const KanjiInfo = preload("res://Game/Menus/KanjiInfo.tscn") 

var kanji_page
var current_list = []
var held_kanji = []
var scroll_start = 0*4 #scroll_start and scroll_end are used to indicate which buttons are loaded.
var scroll_end = 16*4  #by default, it should load the first 16 rows of 4 buttons

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
	#attempted workaround for scroller not working
	#scroll_box.connect("scrolling", self, "_on_Scroller_scroll_started") 
	load_buttons()
	list_selector.connect("select_list", self, "load_list")
	list_kanji_adder.connect("list_add_kanji", self, "add_held_kanji")
	
			
func load_buttons():
	if current_list.size() == 0:
		current_list = range(JapaneseDictionary.size())
		
	for i in current_list.size():
		#if scroll_start > i: #skips first iterations of loop based on scroll
		#	continue
		#elif scroll_end < i: #stops looping at scroll
		#	break
		var button = QuizOption.instance()
		button.set_kanji(current_list[i], true)
		button.holdable=true
		match i%4:
			0:column1.add_child(button)
			1:column2.add_child(button)
			2:column3.add_child(button)
			3:column4.add_child(button)
		button.connect("button_hit", self, "kanji_selected")
		button.connect("button_held", self, "kanji_held")
		button.connect("button_released", self, "kanji_released")
		button.add_to_group("buttons")
func unload_buttons():
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


#scroll_started signal doesn't seem to work.
func _on_Scroller_scroll_started():
	print("test")
	scroll_start = scroll_end
	scroll_end = scroll_end + 4*4
	load_buttons()

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
