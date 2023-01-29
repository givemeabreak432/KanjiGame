extends MenuButton


const path = "res://Assets/lists/"
var popup

onready var notice_box = $NoticeBox

signal list_add_kanji

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _init():
	List.connect("empty_list", self, "show_empty_popup") 
	List.connect("already_in_list", self, "already_added")
	populate_menu()

#Reads what files exists in directory, connecting signal
func populate_menu():
	popup = get_popup()
	var dir = Directory.new()
	for each in List.get_list_keys():
		popup.add_item(each)
	popup.connect("id_pressed", self, "_on_item_pressed")

func reload_directory():
	popup = get_popup()
	popup.clear()
	populate_menu()

#runs when kanji added to list already exists in said list.
func already_added():
	notice_box.dialog_text = "Kanji Already Exists in List!"
	notice_box.visible = true

#on item pressed, we must find  kanji that is being added. We already have the ID of list.
#emit kanji_finder will send message to parent, which should have a kanji to return
#this function simply emits the name of a list for the parent to do the work for calling list.
func _on_item_pressed(id):
	emit_signal("list_add_kanji", List.get_list_keys()[id])
	#List.add_kanji_to_list()
