extends MenuButton


const path = "res://Assets/lists/"
var popup



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _init():
	List.connect("empty_list", self, "show_empty_popup") 
	populate_menu()

#Reads what files exists in directory, connecg signal
func populate_menu():
	popup = get_popup()
	var dir = Directory.new()
	for each in List.get_list_keys():
		popup.add_item(each)
	popup.connect("id_pressed", self, "_on_item_pressed")

func _on_item_pressed(id):
	#List.add_kanji_to_list()
	pass
