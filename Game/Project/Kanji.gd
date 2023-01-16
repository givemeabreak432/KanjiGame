class_name Kanji extends Object

var kanji = ""
var on_yomi = []
var kun_yomi = []
var meaning = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _init():
	pass
	
func kanji_setter(kan, on, kun, mean):
	kanji = kan
	on_yomi = on
	kun_yomi = kun
	meaning = mean
	pass

#all array getters can be passed boolean for string return. By default it is false
func get_kanji():
	return kanji
func get_on_yomi(string = false, del = ""):
	if string:
		return arr_to_string(on_yomi, del)
	return on_yomi
func get_kun_yomi(string = false, del = ""):
	if string:
		return arr_to_string(kun_yomi, del)
	return kun_yomi
func get_meaning(string = false, del = ""):
	if string:
		return arr_to_string(meaning, del)
	return meaning

#simple arr to string method
func arr_to_string(arr, var del = ""):
	var out = ""
	for each in arr:
		out = out + each
		if arr[arr.size()-1] != each:
			out = out + del
	return out

