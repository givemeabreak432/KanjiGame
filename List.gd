#lists will be stored in "lists.txt" file. 
#an individual list will be one line, with the format:
#list_name: kanji1, kanji2, kanji3, etc
#this script contains all lists from list file

extends Node

#load kanji class
const KanjiScript = preload("Kanji.gd")
onready var kanji

#constants
const list_file = "res://Assets/lists/lists.txt"

#variables
var kanji_list = []
var list_dict = {}

#send signals
signal empty_list

# Called when the node enters the scene tree for the first time.
func _ready():
	load_lists()
	pass # Replace with function body.

func _init():
	pass

#reads in the list file, should be ran at script load
func load_lists():
	var file = File.new()
	file.open(list_file, File.READ)
	
	#read file
	while not file.eof_reached():
		var text = file.get_line()
		if text == "":
			break
		elif text.get_slice(":", 1) != "":
			text = text.split(":")
			list_dict[text[0]] = text[1].split(",")
		else:
			list_dict[text.get_slice(":", 0)] = ""
	pass
	
#save newly created list as key value pair to lists.txt
#TODO FIX
func add_list(input):
	var file = File.new()
	file.open(list_file, File.READ_WRITE)
	file.seek_end()
	file.store_string(input + ":" + "\n")
	file.close()
	pass

func get_list_keys():
	return list_dict.keys()

#if key exist, return value.
#otherwise, return whole dictionary
func get_list_values(key):
	if key != null:
		return list_dict[key]
	else:
		return JapaneseDictionary.get_list()
	
func return_entry(entry):
	return kanji_list[entry]
func size():
	return kanji_list.size()
func add_to_list(entry, list):
	pass
