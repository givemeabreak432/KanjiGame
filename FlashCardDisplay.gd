extends Container

#display is only for displaying kanji. It holds the current kanji, but no other information

#loading kanji class
const KanjiScript = preload("Kanji.gd") # Relative path
onready var current_kanji

#node linked var
onready var kanji_label = $HSplitContainer/KanjiTitle/KanjiLabel
onready var on_yomi = $HSplitContainer/KanjiInfo/OnYomi 
onready var kun_yomi = $HSplitContainer/KanjiInfo/KunYomi 
onready var meaning = $HSplitContainer/KanjiInfo/Meaning 
onready var kanji_title = $HSplitContainer/KanjiTitle
onready var kanji_info = $HSplitContainer/KanjiInfo


# Called when the node enters the scene tree for the first time.
func _ready():
	load_entry(0)
	#this seems like bad practice. current requires nested nodes to load.
	get_parent().get_parent().connect("change_kanji", self, "load_entry")
	List.connect("list_created", self, "_reload_directories")
	pass # Replace with function body.


#passed in a kanjiID, set current kanji via dicitionary script. 
func load_entry(entry):
	current_kanji = JapaneseDictionary.get_kanji(entry)
	
	kanji_label.text = current_kanji.get_kanji()
	on_yomi.text = current_kanji.get_on_yomi(true, ", ")
	kun_yomi.text = current_kanji.get_kun_yomi(true, ", ")
	meaning.text = current_kanji.get_meaning(true, ", ")

#flips flashcard
func _on_HSplitContainer_gui_input(event):
	if event.is_pressed():
		kanji_label.visible = not kanji_label.visible
		kanji_info.visible = not kanji_info.visible
	pass # Replace with function body.
