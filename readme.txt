KANJI GAME

kanjiInfo screen will populate based on list of kanji provided for it. By default, this list is the full kanji json "kanji-jouyou.json". Various parameters will let you load custom lists.

Lists should be created as its own class, as there will be methods to add, remove, check for duplicates within lists,, or check for duplicate names.

Current structure:

Lists are collection of Kanji in an array, with some special functions related to kanji.
Default list is all kanji stored in an array and should be loaded in startup.
autoload the dictionary!

-----------scripts------------
AutoLoader:
JapaneseDictionary
-reads kanji.cfg file
-allows lookup for individual kanji
List
-loads config.cfg to hold all lists
-lists are arrays of values. each value is an ID for a kanji held in JapaneseDictionary
Quizsettings
-Holds settings for current quiz - list name, quiz type, etc. 

other scripts:
kanji-
-allows for instantiation of kanji class
-gettings for kanji variables that hold array take 3 arguements:
-boolean as_string, str del, int length
-as_string, if true, returns a string. If false, returns the whole array
-del indicates what to use as a deliminator in string return 
-length refers to how many objects from array to return. 
-You do not have to know length of array to use length, if your number is higher
  than the length, then it will simply return the whole array as a string

kanjiinfo
-holds info regarding currently displayed kanji
-children display  based on display mode that is instanced

dictionarydisplay script
-display mode for kanji - simply a screen of kanji
-getparent.getparent call is awkward. try to fix.s

flashcarddisplay 
-another display mode. Click to flip between kanji and info


quiz
-quiz screen display, pulls info from quizsettings

quizloader
-Settings modification screen
-updates quizsettings script



--------------TODO--------------
Work on list selector:
-duplicate names crash game

japanesedictionary
-refactor romaji converter function, as it's messy. It functions well enough.

kanji-scroller
4 tabs:
kanji - radicals - hiragana - katakana
***added radicals list, however it's a bit hacked together and not 100% accurate
-radicals are just kanji with only 1 radical, but the data-set is incomplete and inaccurate
-Would be better to find another source and just read in a seperate file
-When I make this change, make sure to change JapaneseDictionary parse_dict(), get_radicals(), as well as _on_radicalbutton_pressed() in kanji_scroller
-Radicals should also have their own unique info page
-Katakana and Hiragana should also have their own info pages



Quiz function-
-Extrapolate on QuizLoader settings available 
--number of options
--more quiz types
-Add error catching for lists of length 0
-test editing lists in the middle of quiz. should provide no error.
-add quiz complete error states
-Fix font sizes with longer quiz answers
-radicals quiz?

kanji-stats
-initial stats for kanji completed
-Maybe add more stats based on quiz type taken
-only show quized-on kanji

-other non quiz games?
-Full dictionary - need to find free, online translations
