extends MenuButton

const path = "res://Assets/lists/"
var popup

#node variables
onready var list_creator = $ListCreator
onready var list_deleter = $ListDeleter
onready var list_deleter_menu = $ListDeleter/DeleterContainer/ListDeleter
onready var deleter_confirm = $ListDeleter/DeleteConfirm
onready var empty_list = $EmptyList

#signals
signal select_list

func _ready():
	List.connect("empty_list", self, "show_empty_popup") 
	populate_menu()
	pass 
	
func _init():
	pass

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

func del_list_popup():
	var list_deleter_popup = list_deleter_menu.get_popup()
	list_deleter_popup.clear()
	for each in List.get_list_keys():
		list_deleter_popup.add_item(each)
	list_deleter.visible = true
	

func show_empty_popup():
	empty_list.visible = true
	
#emit signal with list name. lists[ID-2] is necessary because "new' and "delete" are always ID 1 and 2
#in the popup menu, while list array starts at first list
func _on_item_pressed(ID):
	if ID == 0: #create selected
		create_list()
		reload_directory()
	elif ID == 1: #del selected
		del_list_popup()
	elif ID == 2: #dictionary selected
		emit_signal("select_list")
	else: #custom list selected
		emit_signal("select_list", List.get_list_keys()[ID-3])


func _on_ListDeleter_confirmed():
	if(list_deleter_menu.text != ""):
		deleter_confirm.dialog_text = list_deleter_menu.text + " deleted"
		List.delete_list(list_deleter_menu.text)
	else:
		deleter_confirm.dialog_text = "No List Selected"
	list_deleter_menu.text = ""
	deleter_confirm.popup()
