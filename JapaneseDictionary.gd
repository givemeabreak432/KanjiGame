#JapaneseDictionary.gd should be in AutoLoad #1. 
#At startup, it reads in the provided dictionary file

extends Node

#constants
const dict = "res://Assets/lists/kanji-jouyou.json"

#variables
onready var jpn_json #for parsing file
onready var jpn_dict = []
onready var kanji

#loading kanji class
const KanjiScript = preload("Kanji.gd") # Relative path
onready var current_kanji


func _ready():
	load_dict()
	pass # Replace with function body.

#loads dictionary. Can pass in custom dict to load in new dictionary.
func load_dict(file_name = dict):
	var file = File.new()
	file.open(file_name, File.READ)
	var text = file.get_as_text()
	jpn_json = parse_json(text)
	file.close()
	
	#pop up error message and load default list
	if not jpn_json:
		print("attempting to load empty list")
		emit_signal("empty_list")
		load_dict() #calls load_dict with default values
	#creating kanji objects
	else:
		for each in jpn_json.size():
			kanji = Kanji.new()
			kanji.kanji_setter(jpn_json.keys()[each], jpn_json[jpn_json.keys()[each]]["readings_on"], jpn_json[jpn_json.keys()[each]]["readings_kun"], jpn_json[jpn_json.keys()[each]]["meanings"])
			jpn_dict.append(kanji)
	pass

#get_list gets a sub-array of jpn_dict based on IDs
func get_list():
	return jpn_dict
func get_kanji(index):
	return jpn_dict[int(index)]
