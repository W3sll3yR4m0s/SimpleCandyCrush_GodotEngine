extends Node2D

func _on_HomeButton_pressed():
	animate_Anim()
	
	Transition.fade_to("res://Scenes/MainScreen.tscn")
	Transition.clear_above()


func _on_ReplayButton_pressed():
	animate_Anim()
	
	Transition.fade_to("res://Scenes/Level.tscn")
	Transition.clear_above()


func animate_Anim():
	get_node("Anim").play("Hide")
	yield(get_node("Anim"), "finished")
