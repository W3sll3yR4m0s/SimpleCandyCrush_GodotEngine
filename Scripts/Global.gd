extends Node

#=========================================================#
var saveFile = File.new()
var savePath = "user://savegame.save"
var saveData = {"level1": 0,
				"level2": -1,
				"level3": -1,
				"level4": -1,
				"level5": -1,
				"level6": -1}

var currentLevel = 1
var amountStars = 0
#=========================================================#

func _ready():
	if not saveFile.file_exists(savePath):
		save()
	read()

func save():
	saveFile.open(savePath, File.WRITE)
	saveFile.store_var(saveData)
	saveFile.close()

func read():
	saveFile.open(savePath, File.READ)
	saveData = saveFile.get_var()
	saveFile.close()

func save_level(level, amountStars):
	if level > 6: return
	saveData["level" + str(level)] = amountStars
	save()

