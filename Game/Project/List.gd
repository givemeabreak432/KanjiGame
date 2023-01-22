#lists will be stored in "lists.txt" file. 
#an individual list will be one line, with the format:
#list_name: kanji1, kanji2, kanji3, etc
#this script contains all lists from list file

#REFACTOR LIST.TXT TO LIST.CFG


extends Node

#load kanji class
const KanjiScript = preload("res://Game/Project/Kanji.gd")
onready var kanji

#constants
const config_file = "res://Assets/lists/lists.cfg"

#variables
var config = ConfigFile.new()

#send signals
signal empty_list
signal lists_modified #emitted to tell containers to reload lists
signal already_in_list

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
func add_list(input):
	config.set_value("lists", input, Array())
	config.save(config_file)
	emit_signal("lists_modified")

#deletes list from config file
func delete_list(list):
	config.erase_section_key("lists", list)
	config.save(config_file)
	emit_signal("lists_modified")
	
func get_list_keys():
	return config.get_section_keys("lists")
	

#check if list in config file is empty
#if list does not exist, will also return false
func is_empty(list):
	if list != null:return config.get_value("lists", list).size() == 0
	else: return false

#returns saved list based on key (name) provided
#otherwise, return a list of every kanji ID
func get_list_values(list):
	if list != null and list in get_list_keys():
		if not is_empty(list):
			return config.get_value("lists", list)
		else: #selected list is empty
			emit_signal("empty_list")
			return range(JapaneseDictionary.size())
	else:
		return range(JapaneseDictionary.size())

func get_list_size(list):
	return config.get_value("lists", list).size()

#TODO - sort list_entries, check for duplicates
#add kanji "entry number" to list and stores in saved document.
func add_kanji_to_list(list, entry):
	
	#Update stored dictionary
	var list_entries = config.get_value("lists", list)
	if int(entry) in list_entries:
		emit_signal("already_in_list")
	else:
		list_entries.append(int(entry))
		list_entries.sort()
		#save list_entries to config file to config file
		
		config.set_value("lists", list, list_entries)
		config.save(config_file)
	
func remove_kanji_from_list(list, entry):
	print(entry)
	var list_entries = config.get_value("lists", list)
	if entry in list_entries:
		list_entries.erase(int(entry))
		config.set_value("lists", list, list_entries)
		config.save(config_file)
