#JapaneseDictionary.gd should be in AutoLoad #1. 
#At startup, it reads in the provided dictionary file into config folder
#kanji are stored in config folder and pulled from config folder when needed.
#conji.cfg stores kanji in the format:
#"section" = ID
#key = kanji, onyomi, kunyomi, meaning
#value = value
extends Node

#constants
const dict = "res://Assets/lists/kanji-jouyou.json"
const config_file = "res://Assets/lists/kanji.cfg"

#variables
onready var jpn_json #for parsing file
var config = ConfigFile.new()

#loading kanji class
const KanjiScript = preload("res://Game/Project/Kanji.gd") # Relative path


func _ready():
	config.load(config_file)
	if config.get_sections().size() == 0:
		parse_dict() #auto run load dict on first time startup.
	pass # Replace with function body.

#loads dictionary given based on path. 
#adds "kanji" section to config_file. 
func parse_dict(file_name = dict):
	var file = File.new()
	file.open(file_name, File.READ)
	var text = file.get_as_text()
	jpn_json = parse_json(text)
	file.close()
	
	#pop up error message and load default list
	if not jpn_json:
		print("attempting to load empty list")
		emit_signal("empty_list")
		parse_dict() #calls parse_dict with default values
	#creating kanji objects
	else:
		var i = 0
		for each in jpn_json.size():
			config.set_value(str(i), "kanji", jpn_json.keys()[each])
			config.set_value(str(i), "on_yomi", jpn_json[jpn_json.keys()[each]]["readings_on"])
			config.set_value(str(i), "kun_yomi",  jpn_json[jpn_json.keys()[each]]["readings_kun"])
			config.set_value(str(i), "meanings", jpn_json[jpn_json.keys()[each]]["meanings"])
			config.set_value(str(i), "radicals", jpn_json[jpn_json.keys()[each]]["wk_radicals"])
			i+=1
		config.save(config_file)
			
#search throuhgh dictionary for relevent kanji based on kun, on, or meaning
#returns a list of IDs
#returns full list if return is size 0
func search(text = ""):
	var text_hiragana = translate_romaji(text)
	var search_list = []
	for i in size():
		var kanji = get_kanji(i)
		if text.to_lower() in kanji.get_meaning(true, " ").to_lower():
			search_list.append(i)
		elif text == kanji.get_kanji() or text_hiragana in kanji.get_kun_yomi(true, " ") or text_hiragana in kanji.get_on_yomi(true, " "):
			search_list.append(i)
	if search_list.size() == 0:
		search_list = range(size())
	return search_list

#returns number of sections (kanji) in kanfig folder
func size():
	return config.get_sections().size()
	
func get_kanji(index):
	var kanji = Kanji.new()
	kanji.kanji_setter(config.get_value(str(index), "kanji"), config.get_value(str(index), "on_yomi"), 
	  config.get_value(str(index), "kun_yomi"), config.get_value(str(index), "meanings"))
	return kanji

func get_radicals():
	var radicals = []
	for each in size():
		print(config.get_value(str(each), "radicals"))
		if config.get_value(str(each), "radicals"):
			if config.get_value(str(each), "radicals").size() == 1:
				radicals.append(each)
	return radicals

#translates romaji to hiragana
func translate_romaji(input):
	input = input.replace(" ", "").to_lower()
	var output = ""
	var i = 0
	var inserted_y = false
	while i < input.length():
		if input[i] == "a" or input[i] == "i" or input[i] == "u" or input[i] == "e" or input[i] == "o":
			match input[i]:
				"a": output+="あ"
				"i": output+= "い"
				"u": output+= "う"
				"e": output+= "え"
				"o": output+= "お"
			i+=1
			continue
		else:
			if input[i] == "n":
				if i + 1 < input.length():
					if (input[i+1] == "a" or input[i+1] == "i" or input[i+1] == "u" or input[i+1] == "e" or input[i+1] == "o"):
						pass
					else:
						output+="ん"
						i+=1
						continue
				else:
					output+="ん"
					i+=1
					continue
			if i+1 < input.length(): #make sure next character exists
				if i+2 < input.length() and input.substr(i,2) == "ch" and not inserted_y: #preparing little y: cha
					if input.substr(i,3) == "chi":
						pass #no adding characters, chi is covered laterr
					else:
						input = input.insert(i+2, "iy") #chu -> chi+yu
						inserted_y = true
				if i+2 < input.length() and input[i+1] == "y" and not inserted_y: #preparing little y: kya
					input = input.insert(i+1, "i") #kya -> ki + ya
					inserted_y = true
				if input.substr(i, 2) == "ju":
					input = input.insert(i+1, "iy") #ju -> ji + yu
					inserted_y = true
				if input[i+1] == "a" or input[i+1] == "i" or input[i+1] == "u" or input[i+1] == "e" or input[i+1] == "o":
					match input.substr(i,2): #excludes shi, chi, tsu, dji, dzu
						"ka":output+="か"
						"ki":output+="き"
						"ku":output+="く"
						"ke":output+="け"
						"ko":output+="こ"
						"sa":output+="さ"
						"su":output+="す"
						"se":output+="せ"
						"so":output+="そ"
						"ta":output+="た"
						"te":output+="て"
						"to":output+="と"
						"na":output+="な"
						"ni":output+="に"
						"nu":output+="ぬ"
						"ne":output+="ね"
						"no":output+="の"
						"ha":output+="は"
						"hi":output+="ひ"
						"fu":output+="ふ"
						"he":output+="へ"
						"ho":output+="ほ"
						"ma":output+="ま"
						"mi":output+="み"
						"mu":output+="む"
						"me":output+="め"
						"mo":output+="も"
						"ya":
							if inserted_y: output+="ゃ"
							else: output+="や"
							inserted_y = false
						"yu": 
							if inserted_y: output+="ゅ"
							else:output+="ゆ"
							inserted_y = false
						"yo":
							if inserted_y: output+="ょ"
							else: output+="よ"
							inserted_y = false
						"ra":output+="ら"
						"ri":output+="り"
						"ru":output+="る"
						"re":output+="れ"
						"ro":output+="ろ"
						"wa":output+="わ"
						"wo":output+="を"
						"ga":output+="が"
						"gi":output+="ぎ"
						"gu":output+="ぐ"
						"ge":output+="げ"
						"go":output+="ご"
						"za":output+="ざ"
						"ji":output+="じ"
						"zu":output+="ず"
						"ze":output+="ぜ"
						"zo":output+="ぞ"
						"da":output+="だ"
						"de":output+="で"
						"do":output+="ど"
						"ba":output+="ば"
						"bi":output+="び"
						"bu":output+="ぶ"
						"be":output+="べ"
						"bo":output+="ぼ"
						"pa":output+="ぱ"
						"pi":output+="ぴ"
						"pu":output+="ぷ"
						"pe":output+="ぺ"
						"po":output+="ぽ"
						_:
							output+=input[i]
							i-=1
					#skips next character
					i+=2
					continue
				elif input[i] == input[i+1]: #double consonant
					output+="っ" #bocchi
					i+=1
					continue
				elif i + 2 < input.length(): # 3 character combos
					if input[i+2] != "y":
						match input.substr(i,3):
							"shi":
								output += "し"
								i+=3
							"chi":
								output += "ち"
								i+=3
							"tsu":
								output += "つ"
								i+=3
							"dji":
								output += "ぢ"
								i+=3
							"dzu":
								output += "づ"
								i+=3
							_:
								output+=input[i]
								i+=1
						continue
					else:
						output += input[i]
						i+=1
						continue
				else:
					output+= input[i]
					i+=1
					continue
			else:
				output += input[i]
				i+=1
				continue
	return output
	
