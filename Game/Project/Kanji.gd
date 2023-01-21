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
#all getters can also pass "length" node to subset string to first x of array
func get_kanji():
	return kanji
func get_on_yomi(string = false, del = "", length = null):
	if string:
		return arr_to_string(on_yomi, del, length)
	return on_yomi
func get_kun_yomi(string = false, del = "", length = null):
	if string:
		return arr_to_string(kun_yomi, del, length)
	return kun_yomi
func get_meaning(string = false, del = "", length=null):
	if string:
		return arr_to_string(meaning, del, length)
	return meaning

#Converts an array to a string, using the deliminter provided. If a length is passed in
#will stop the string conversion early
func arr_to_string(arr, var del = "", length=null):
	var out = ""
	var i = 0
	for each in arr:
		out += each
		i+=1
		if i == length:
			return out
		if arr[arr.size()-1] != each:
			out += del
	return out

