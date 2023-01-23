extends Control
#kanji scroller is a list of all kanji dispalyed by kanji
#selecting a kanji will take you to kanji-info screen for selected kanji
#reuses QuizOption scene for buttons - may need to make custom scene later.

const QuizOption = preload("res://Game/Quiz/QuizOption.tscn")
const KanjiInfo = preload("res://Game/Menus/KanjiInfo.tscn") 

var kanji_page
var search_list = []
var scroll_start = 0*4 #scroll_start and scroll_end are used to indicate which buttons are loaded.
var scroll_end = 16*4  #by default, it should load the first 16 rows of 4 buttons

onready var column1 = $VBox/Scroller/ScrollMargins/Row/Column1
onready var column2 = $VBox/Scroller/ScrollMargins/Row/Column2
onready var column3 = $VBox/Scroller/ScrollMargins/Row/Column3
onready var column4 = $VBox/Scroller/ScrollMargins/Row/Column4
onready var scroll_box = $VBox/Scroller
onready var VBox = $VBox


func _ready():
	#attempted workaround for scroller not working
	#scroll_box.connect("scrolling", self, "_on_Scroller_scroll_started") 
	load_buttons()
			
func load_buttons():
	if search_list.size() == 0:
		search_list = range(JapaneseDictionary.size())
		
	for i in search_list.size():
		#if scroll_start > i: #skips first iterations of loop based on scroll
		#	continue
		#elif scroll_end < i: #stops looping at scroll
		#	break
		var button = QuizOption.instance()
		button.set_kanji(search_list[i], true)
		match i%4:
			0:column1.add_child(button)
			1:column2.add_child(button)
			2:column3.add_child(button)
			3:column4.add_child(button)
		button.connect("button_hit", self, "kanji_selected")
		
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
	search_list = JapaneseDictionary.search(text)
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
	search_list = JapaneseDictionary.get_radicals()
	unload_buttons()
	load_buttons()
