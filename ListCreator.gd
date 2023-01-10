extends PopupPanel

const path = "res://Assets/lists/"
onready var entry = $VBoxContainer/Entry
onready var existence_label = $VBoxContainer/AlreadyExists

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
func create_list():
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		
		#check for duplicate names
		var file_name = dir.get_next()

		#write file
		if not (dir.file_exists(entry.text + ".json")):
			var file = File.new()
			file.open("res://Assets/lists/" + entry.text + ".json", File.WRITE)
			file.close()
			get_parent().reload_directory()
			_on_CloseButton_pressed()
		else:
			existence_label.visible = true
			


#signal functions
func _on_CloseButton_pressed():
	entry.text = "Enter Name"
	hide()
	pass # Replace with function body.


func _on_CreateButton_pressed():
	create_list()
	pass
