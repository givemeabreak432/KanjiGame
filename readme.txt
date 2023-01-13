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

Kanji Dictionary Display:
-Add different display modes:
-Flash Card Display
-instance "info container" to have different types of displays
-move kanjiinfo script to dictionarydisplay and flash card display

kanji search function
-Dynamically create sublist based on given critiera
-meaning, onyomi, kunyomi, etc
