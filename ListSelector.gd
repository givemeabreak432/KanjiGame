extends MenuButton

const path = "res://Assets/lists/"
var popup
var lists = []

#node variables
onready var list_creator = $ListCreator
onready var empty_list = $EmptyList

#signals
signal select_list

func _ready():
	#connect_signals
	pass 
	
func _init():
	read_directory()

#possibly add functionality for sub-folders in future
func read_directory():
	popup = get_popup()
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		
		var file_name = dir.get_next()
		while file_name != "":
			if not (file_name == "." or file_name == ".."):
				lists.append(file_name)
				popup.add_item(file_name)
			file_name = dir.get_next()
	#popup has "id_pressed" signal built in, connect to custom function _on_item_pressed()
	popup.connect("id_pressed", self, "_on_item_pressed")

#remakes popup menu, to be called after creating new files
func reload_directory():
	popup = get_popup()
	popup.clear()
	popup.add_item("New")
	popup.add_item("Delete")
	read_directory()

#makes "create list" menu visible
func create_list():
	list_creator.popup()
	pass

func del_list():
	pass

func show_empty_popup():
	empty_list.visible = true
	pass
#emit signal with list name. lists[ID-2] is necessary because "new' and "delete" are always ID 1 and 2
#in the popup menu, while list array starts at first list
func _on_item_pressed(ID):
	if ID == 0: 
		create_list()
		pass
	elif ID == 1:
		del_list()
		pass
	else:
		emit_signal("select_list", lists[ID-2])
	pass
