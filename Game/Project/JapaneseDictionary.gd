#JapaneseDictionary.gd should be in AutoLoad #1. 
#At startup, it reads in the provided dictionary file into config folder
#kanji are stored in config folder and pulled from config folder when needed.
#conji.cfg stores kanji in the format:
#"section" = ID
#key = kanji, onyomi, kunyomi, meaning
#value = value
extends Node

#constants
const dict = "res://Assets/lists/kanji-jouyou.json"
const config_file = "res://Assets/lists/kanji.cfg"

#variables
onready var jpn_json #for parsing file
var config = ConfigFile.new()

#loading kanji class
const KanjiScript = preload("res://Game/Project/Kanji.gd") # Relative path


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
			config.set_value(str(i), "radicals", jpn_json[jpn_json.keys()[each]]["wk_radicals"])
			i+=1
		config.save(config_file)
			
#search throuhgh dictionary for relevent kanji based on kun, on, or meaning
#returns a list of IDs
#returns full list if return is size 0
func search(text = ""):
	var search_list = []
	for i in size():
		var kanji = get_kanji(i)
		if text.to_lower() in kanji.get_meaning(true).to_lower():
			search_list.append(i)
		elif text == kanji.get_kanji() or text in kanji.get_kun_yomi() or text in kanji.get_on_yomi():
			search_list.append(i)
	if search_list.size() == 0:
		search_list = range(size())
	return search_list

#returns number of sections (kanji) in kanfig folder
func size():
	return config.get_sections().size()
	
func get_kanji(index):
	var kanji = Kanji.new()
	kanji.kanji_setter(config.get_value(str(index), "kanji"), config.get_value(str(index), "on_yomi"), 
	  config.get_value(str(index), "kun_yomi"), config.get_value(str(index), "meanings"))
	return kanji

func get_radicals():
	var radicals = []
	for each in size():
		print(config.get_value(str(each), "radicals"))
		if config.get_value(str(each), "radicals"):
			if config.get_value(str(each), "radicals").size() == 1:
				radicals.append(each)
	return radicals
