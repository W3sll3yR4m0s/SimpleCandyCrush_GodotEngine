extends Area2D

#========================================================#
var x
var y

var destinyX
var destinyY
var positionX
var positionY

var numberColor
var special = false

var selected = false

var allow_Selection = true # WR #

signal selectedCandy(obj, selected)
#========================================================#

func _ready():
	randomize()
	
	numberColor = int(rand_range(0, 6))
	
	if rand_range(0, 1) > 0.99:
		special = true
	
	if special:
		get_node("Sprite").set_animation("shine" + get_color(numberColor))
	else:
		get_node("Sprite").set_animation("normal" + get_color(numberColor))
	
	set_process(true)


func _process(delta):
	if ( destinyX == null or destinyY == null or (destinyX == x and destinyY == y) ): return
	
	var deltaDistanceX = positionX - get_pos().x
	var deltaDistanceY = positionY - get_pos().y
	
	var speed = Vector2(0, 0)
	
	if abs(deltaDistanceX) > 20:
		speed.x = 275*(destinyX - x)
	else:
		set_pos(Vector2(positionX, get_pos().y))
		x = destinyX
	if abs(deltaDistanceY) > 20:
		speed.y = 275*(destinyY - y)
	else:
		set_pos(Vector2(get_pos().x, positionY))
		y = destinyY
	
	set_pos(get_pos() + speed * delta)


func get_color(numberColor):
	if numberColor == 0:
		return "Blue"
	elif numberColor == 1:
		return "Green"
	elif numberColor == 2:
		return "Orange"
	elif numberColor == 3:
		return "Pink"
	elif numberColor == 4:
		return "Purple"
	elif numberColor == 5:
		return "Yellow"


func _on_Candy_input_event( viewport, event, shape_idx ):
	if event.type == InputEvent.SCREEN_TOUCH and event.pressed and shape_idx != -1:
		if selected and allow_Selection:
			deselect()
			emit_signal("selectedCandy", self, false)
		elif not selected:
			select()
			emit_signal("selectedCandy", self, true)
		else:
			return

func deselect():
	selected = false
	get_node("SelectedOver").hide()
	get_node("SelectedUnder").hide()
	
	allow_Selection = true # WR #

func select():
	selected = true
	get_node("SelectedOver").show()
	get_node("SelectedUnder").show()

func set_data(x, y):
	allow_Selection = false # WR #
	
	self.x = x
	self.y = y
	
	set_pos(Vector2( 62 + (x * 75) + (75/2), 290 + (y * 75) + (75/2)))

func move_to(goX, goY):
	allow_Selection = false # WR #
	
	destinyX = goX
	destinyY = goY
	
	positionX = get_pos().x + (goX - x) * 75
	positionY = get_pos().y + (goY - y) * 75

