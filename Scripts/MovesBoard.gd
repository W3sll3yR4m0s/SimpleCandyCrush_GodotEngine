extends Sprite

var moves = 5 # PADRÃO: 30 #

func _ready():
	update_Number()

func set_moves(m):
	moves = m
	update_Number()

func update_Number():
	if ( moves >= 0 ):
		get_node("Number1").set_texture(load("res://SharyTheFairy/files/png/gui/Group_" + str(moves/10) + ".png"))
		get_node("Number2").set_texture(load("res://SharyTheFairy/files/png/gui/Group_" + str(moves%10) + ".png"))
	else:
		return

func _on_Candies_played():
	moves -= 1
	update_Number()
