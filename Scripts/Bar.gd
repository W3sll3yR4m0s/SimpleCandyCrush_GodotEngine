extends Sprite

export(String, FILE) var starOn

var points = 0

var p3 = 100
var p1 = (135.0/408)*p3
var p2 = (p1 + p3)/2

func _ready():
	starOn = load(starOn)

func set_max(maximumScore):
	p3 = maximumScore
	p1 = (135.0/408)*p3
	p2 = (p1 + p3)/2


func _on_Candies_add_points( points ):
	self.points += points
	if self.points > p3: self.points = p3
	get_node("Green").set_region_rect(Rect2(0, 0, (408 * self.points)/p3, 42))
	
	if self.points >= p3:
		Global.amountStars = 3
		get_node("Star3").set_texture(starOn)
	elif self.points >= p2:
		Global.amountStars = 2
		get_node("Star2").set_texture(starOn)
	elif self.points >= p1:
		Global.amountStars = 1
		get_node("Star1").set_texture(starOn)

func win():
	return points >= p1

func recordMax():
	return points >= p3

