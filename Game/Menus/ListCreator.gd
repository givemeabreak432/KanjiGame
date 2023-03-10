extends PopupPanel

const path = "res://Assets/lists/"
onready var entry = $VBoxContainer/Entry
onready var existence_label = $VBoxContainer/AlreadyExists

func _ready():
	pass 
	
	
func create_list():
	if ":" in entry.text:
		invalid_entry()
	elif not entry.text in List.get_list_keys():
		List.add_list(entry.text)
		_on_CloseButton_pressed()
	else:
		existence_label.visible = true
		existence_label.visible = ""
			

func invalid_entry():
	existence_label.visible=true
	existence_label.text="No special characters"
	

#signal functions
func _on_CloseButton_pressed():
	entry.text = "Enter Name"
	hide()
	pass # Replace with function body.


func _on_CreateButton_pressed():
	create_list()
	pass
