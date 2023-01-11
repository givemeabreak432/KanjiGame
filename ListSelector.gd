extends MenuButton

const path = "res://Assets/lists/"
var popup

#node variables
onready var list_creator = $ListCreator
onready var empty_list = $EmptyList

#signals
signal select_list

func _ready():
	#connect_signals
	pass 
	
func _init():
	populate_menu()

#Reads what files exists in directory, connecg signal
func populate_menu():
	popup = get_popup()
	var dir = Directory.new()
	for each in List.get_list_keys():
		popup.add_item(each)
	#popup has "id_pressed" signal built in, connect to custom function _on_item_pressed()
	popup.connect("id_pressed", self, "_on_item_pressed")

#remakes popup menu, to be called after creating new files
func reload_directory():
	popup = get_popup()
	popup.clear()
	popup.add_item("New")
	popup.add_item("Delete")
	popup.add_item("Dictionary")
	populate_menu()

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
	if ID == 0: #create selected
		create_list()
		pass
	elif ID == 1: #del selected
		del_list()
		pass
	elif ID == 2: #dictionary selected
		emit_signal("select_list")
	else: #custom list selected
		emit_signal("select_list", List.get_list_keys()[ID-3])
	pass
