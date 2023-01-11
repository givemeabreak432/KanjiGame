extends PopupPanel

const path = "res://Assets/lists/"
onready var entry = $VBoxContainer/Entry
onready var existence_label = $VBoxContainer/AlreadyExists

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
	
func create_list():
	if not entry.text in List.get_list_keys():
		List.add_list(entry.text)
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
