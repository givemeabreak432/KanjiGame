class_name List extends Object

#load kanji class
const KanjiScript = preload("Kanji.gd") # Relative path
onready var kanji

#variables
var jpn_dict = {}
var kanji_list = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _init():
	pass

func load_dict():
	var file = File.new()
	file.open("res://Assets/kanji-jouyou.json", File.READ)
	var text = file.get_as_text()
	jpn_dict = parse_json(text)
	file.close()
	
	#creating kanji objects
	for each in jpn_dict.size():
		kanji = Kanji.new()
		kanji.kanji_setter(jpn_dict.keys()[each], jpn_dict[jpn_dict.keys()[each]]["readings_on"], jpn_dict[jpn_dict.keys()[each]]["readings_kun"], jpn_dict[jpn_dict.keys()[each]]["meanings"])
		kanji_list.append(kanji)
	pass

func return_entry(entry):
	return kanji_list[entry]
func size():
	return kanji_list.size()

func add_to_list(entry, list):
	pass

