#JapaneseDictionary.gd should be in AutoLoad #1. 
#At startup, it reads in the provided dictionary file into config folder
#kanji are stored in config folder and pulled from config folder when needed.
#conji.cfg stores kanji in the format:
#"section" = ID
#key = kanji, onyomi, kunyomi, meaning
#value = value
#jpn dict is an array of kanji
extends Node

#constants
const dict = "res://Assets/lists/kanji-jouyou.json"
const config_file = "res://Assets/lists/kanji.cfg"

#variables
onready var jpn_json #for parsing file
onready var jpn_dict = []
onready var kanji
var config = ConfigFile.new()

#loading kanji class
const KanjiScript = preload("res://Game/Project/Kanji.gd") # Relative path
onready var current_kanji


func _ready():
	config.load(config_file)
	if config.get_sections().size() == 0:
		parse_dict() #auto run load dict on first time startup.
	pass # Replace with function body.

#loads dictionary given based on path. 
#adds "kanji" section to config_file. 
func parse_dict(file_name = dict):
	var file = File.new()
	file.open(file_name, File.READ)
	var text = file.get_as_text()
	jpn_json = parse_json(text)
	file.close()
	
	#pop up error message and load default list
	if not jpn_json:
		print("attempting to load empty list")
		emit_signal("empty_list")
		parse_dict() #calls parse_dict with default values
	#creating kanji objects
	else:
		var i = 0
		for each in jpn_json.size():
			config.set_value(str(i), "kanji", jpn_json.keys()[each])
			config.set_value(str(i), "on_yomi", jpn_json[jpn_json.keys()[each]]["readings_on"])
			config.set_value(str(i), "kun_yomi",  jpn_json[jpn_json.keys()[each]]["readings_kun"])
			config.set_value(str(i), "meanings", jpn_json[jpn_json.keys()[each]]["meanings"])
			i+=1
		config.save(config_file)

			
#search throuhgh dictionary for relevent kanji based on kun, on, or meaning
#returns a list of indexes
#returns full list if return is size 0
func search(text = ""):
	var index_list = []
	for i in jpn_dict.size():
		if text in jpn_dict[i].get_meaning(true).to_lower():
			index_list.append(i)
	if index_list.size() == 0:
		index_list = range(jpn_dict.size())
	return index_list

#get_list gets a sub-array of jpn_dict based on IDs
func get_list():
	return jpn_dict

#returns number of sections (kanji) in kanfig folder
func size():
	return config.get_sections().size()
	
func get_kanji(index):
	kanji = Kanji.new()
	kanji.kanji_setter(config.get_value(str(index), "kanji"), config.get_value(str(index), "on_yomi"), 
	  config.get_value(str(index), "kun_yomi"), config.get_value(str(index), "meanings"))
	return kanji
