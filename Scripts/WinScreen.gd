extends Node2D

export(String, FILE) var starOn

var numberStarsLevel

func _ready():
	numberStarsLevel = Global.amountStars
	
	var level = Global.currentLevel
	Global.save_level(level, numberStarsLevel)
	
	if ( Global.saveData["level" + str(level) + 1] == -1 ):
		Global.save_level(level + 1, 0)
	
	if numberStarsLevel >= 2:
		get_node("Sprite/Star2").set_texture(load(starOn))
	if numberStarsLevel >= 3:
		get_node("Sprite/Star3").set_texture(load(starOn))

func _on_HomeButton_pressed():
	animate_Anim()
	
	Transition.fade_to("res://Scenes/MainScreen.tscn")
	Transition.clear_above()


func _on_ReplayButton_pressed():
	animate_Anim()
	
	Transition.fade_to("res://Scenes/Level.tscn")
	Transition.clear_above()


func _on_NextButton_pressed():
	animate_Anim()
	
	Global.currentLevel += 1
	if Global.currentLevel > 6:
		Transition.fade_to("res://Scenes/MainScreen.tscn")
	else:
		Transition.fade_to("res://Scenes/Level.tscn")
	
	Transition.clear_above()


func animate_Anim():
	get_node("Anim").play("Hide")
	yield(get_node("Anim"), "finished")

