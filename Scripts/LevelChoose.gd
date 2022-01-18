extends Area2D

export(int) var level = 0
export(String, FILE) var marker_unlock
export(String, FILE) var star1
export(String, FILE) var star2
export(String, FILE) var star3

var amountStars

func _ready():
	amountStars = Global.saveData["level" + str(level)]
	
	if amountStars != -1:
		get_node("Lock").set_texture(load(marker_unlock))
		if amountStars != 0:
			get_node("Stars").show()
	
		if amountStars == 1:
			get_node("Stars").set_texture(load(star1))
		elif amountStars == 2:
			get_node("Stars").set_texture(load(star2))
		elif amountStars == 3:
			get_node("Stars").set_texture(load(star3))
	
	get_node("Number").set_texture(load("res://SharyTheFairy/files/png/gui/Group_" + str(level) + ".png"))


func _on_Level_input_event( viewport, event, shape_idx ):
#	print(event)
	if event.type == InputEvent.SCREEN_TOUCH and event.pressed and amountStars != -1:
		Global.currentLevel = level
		Transition.fade_to("res://Scenes/Level.tscn")
