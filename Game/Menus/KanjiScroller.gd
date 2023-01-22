extends Control
#kanji scroller is a list of all kanji dispalyed by kanji
#selecting a kanji will take you to kanji-info screen for selected kanji
#reuses QuizOption scene for buttons - may need to make custom scene later.

const QuizOption = preload("res://Game/Quiz/QuizOption.tscn")
const KanjiInfo = preload("res://Game/Menus/KanjiInfo.tscn") 

var kanji_page

onready var column1 = $Scroller/Row/Column1
onready var column2 = $Scroller/Row/Column2
onready var column3 = $Scroller/Row/Column3
onready var column4 = $Scroller/Row/Column4
onready var scroller = $Scroller


func _ready():
	for i in JapaneseDictionary.size():
		var button = QuizOption.instance()
		button.set_kanji(i, true)
		match i%4:
			0:column1.add_child(button)
			1:column2.add_child(button)
			2:column3.add_child(button)
			3:column4.add_child(button)
			
		button.connect("button_hit", self, "kanji_selected")

#displays kanji info screen
func kanji_selected(kanji_id):
	kanji_page = KanjiInfo.instance()
	scroller.visible = false
	add_child(kanji_page)
	kanji_page.load_page(kanji_id)
	kanji_page.connect("close_screen", self, "close_kanji_screen")

func close_kanji_screen():
	remove_child(kanji_page)
	kanji_page.queue_free()
	scroller.visible = true
