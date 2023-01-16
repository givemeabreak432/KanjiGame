KANJI GAME

kanjiInfo screen will populate based on list of kanji provided for it. By default, this list is the full kanji json "kanji-jouyou.json". Various parameters will let you load custom lists.

Lists should be created as its own class, as there will be methods to add, remove, check for duplicates within lists,, or check for duplicate names.

Current structure:

Lists are collection of Kanji in an array, with some special functions related to kanji.
Default list is all kanji stored in an array and should be loaded in startup.
autoload the dictionary!

TODO:
Work on list selector. 
-create new lists DONE
-delete lists
-load lists - DONE
-append kanji to lists DONE
-remove kanji from list - DONE


kanji search function
-Dynamically create sublist based on given critiera
-meaning, onyomi, kunyomi, etc
-currently only searches through meaning
-possibly romaji search for on/kun

Quiz function-
-QuizSettings holds quiz settings set in QuizLoader. 
-Extrapolate on QuizLoader settings available 
-Add error catching for lists of length 0
-QuizLength function, should always be less than length of list.
-add quiz complete error states

kanjiinfo script
-this script has evolved to hold information regarding current kanji, list, display etc
-this will be passed to display scripts nested inside

dictionarydisplay script
-getparent.getparent call is awkward. try to fix.
