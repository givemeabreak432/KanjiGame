#lists will be stored in "lists.txt" file. 
#an individual list will be one line, with the format:
#list_name: kanji1, kanji2, kanji3, etc
#this script contains all lists from list file

#REFACTOR LIST.TXT TO LIST.CFG


extends Node

#load kanji class
const KanjiScript = preload("Kanji.gd")
onready var kanji

#constants
const config_file = "res://Assets/lists/lists.cfg"

#variables
var list_dict = {} #this stores the doc file in the form of key = dic name: value = string array of entry values
var config = ConfigFile.new()

#send signals
signal empty_list
signal list_created #whenever lists are updated, list_created is emitte to update relevent menus

# Called when the node enters the scene tree for the first time.
func _ready():
	load_lists()
	pass # Replace with function body.

func _init():
	pass

#reads in the list file, should be ran at script load
#keep in mind, a dictionary in the form:
#KEY: ARRAY OF STRINGS
#when calling a number, make sure to change to INT!
func load_lists():	
	config.load(config_file)
	
#save newly created list as key value pair to lists.txt
#also adds list as new value
#TODO FIX
func add_list(input):
	config.set_value("lists", input, PoolStringArray())
	config.save(config_file)
	pass

func get_list_keys():
	return config.get_section_keys("lists")

#returnss saved list based on key (name) provided
#otherwise, return a list of every kanji ID, 0-list().size()
func get_list_values(key):
	if key != null:
		if config.get_value("lists", key).size() != 0:
			return config.get_value("lists", key)
		else: #selected list is empty
			emit_signal("empty_list")
			return range(JapaneseDictionary.get_list().size())
	else:
		return range(JapaneseDictionary.get_list().size())


#TODO - sort list_entries, check for duplicates
#add kanji "entry number" to list and stores in saved document.
func add_kanji_to_list(list, entry):
	
	#Update stored dictionary
	var list_entries = config.get_value("lists", list)
	list_entries.append(entry)
	
	#save list_entries to config file to config file
	
	config.set_value("lists", list, list_entries)
	config.save(config_file)
	pass
