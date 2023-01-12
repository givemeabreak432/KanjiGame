extends MenuButton


const path = "res://Assets/lists/"
var popup

signal list_add_kanji

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

#on item pressed, we must find  kanji is being added. We already have the ID of list.
#emit kanji_finder will send message to parent, which should have a kanji to return
func _on_item_pressed(id):
	emit_signal("list_add_kanji", id)
	#List.add_kanji_to_list()
	pass
