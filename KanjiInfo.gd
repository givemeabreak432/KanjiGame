extends MarginContainer
#importing class
const DefaultManager = preload("List.gd") # Relative path
onready var default_manager = DefaultManager.new()

#global var
var jpn_dict = {}
var current_page = 0
#node linked var
onready var kanji_label = $VBoxContainer/InfoContainer/KanjiTitle/KanjiLabel
onready var on_yomi = $VBoxContainer/InfoContainer/KanjiInfo/OnYomi #line 6
onready var kun_yomi = $VBoxContainer/InfoContainer/KanjiInfo/KunYomi # line 7
onready var meaning = $VBoxContainer/InfoContainer/KanjiInfo/Meaning # line 5
onready var page = $VBoxContainer/NavigationContainer/Page # page counter



# Called when the node enters the scene tree for the first time.
func _ready():
	load_dict()
	load_entry(current_page)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#load json into global jpn_dict
func load_dict():
	var file = File.new()
	file.open("res://Assets/kanji-jouyou.json", File.READ)
	var text = file.get_as_text()
	jpn_dict = parse_json(text)
	file.close()
	pass

#reloads current page dsiplayed with entry #
func load_entry(entry):
	kanji_label.text = jpn_dict.keys()[entry]
	on_yomi.text = arr_to_string(jpn_dict[jpn_dict.keys()[entry]]["readings_on"], ", ")
	kun_yomi.text = arr_to_string(jpn_dict[jpn_dict.keys()[entry]]["readings_kun"], ", ")
	meaning.text = arr_to_string(jpn_dict[jpn_dict.keys()[entry]]["meanings"], ", ")
	page.text = str(entry + 1) + "/" + str(jpn_dict.size())

#simple array to string function
func arr_to_string(arr, var del = ""):
	var out = ""
	for each in arr:
		out = out + each
		if arr[arr.size()-1] != each:
			out = out + del
	return out

func add_to_list(entry, list):
	pass



#BUTTON FUNCTIONS
#navigate to previous kanji page
func _on_LeftButton_pressed():
	current_page = current_page - 1
	if current_page < 0:
		current_page = jpn_dict.size() - 1		
	load_entry(current_page)
	pass # Replace with function body.

#navigate to next kanji page
func _on_RightButton_pressed():
	current_page = current_page + 1
	if current_page == jpn_dict.size():
		current_page = 0
	load_entry(current_page)
	pass # Replace with function body.


func _on_BackButton_pressed():
	get_tree().change_scene("res://TitleScreen.tscn")
	pass # Replace with function body.
