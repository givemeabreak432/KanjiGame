extends MarginContainer

#global var
var jpn_dict = {}
#node linked var
onready var kanji_label = $HBoxContainer/KanjiTitle/KanjiLabel



# Called when the node enters the scene tree for the first time.
func _ready():
	load_dict()
	kanji_label.text = str(jpn_dict)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#load json into global jpn_dict
func load_dict():
	var file = File.new()
	file.open("res://Assets/kanji-jouyou.json", File.READ)
	var text = file.get_as_text()
	jpn_dict = parse_json(text)
	file.close()
	pass