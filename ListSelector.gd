extends MenuButton
const path = "res://Assets/lists/"
var popup
var lists = []

#signals
signal select_list

func _ready():
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
	popup.connect("id_pressed", self, "_on_item_pressed")


#emit signal with list name
func _on_item_pressed(ID):
	emit_signal("select_list", lists[ID])
	pass