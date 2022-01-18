extends CanvasLayer

var nextScenePath

var above_node

func fade_to(path):
	nextScenePath = path
	get_node("Anim").play("Fade")

func change_scene():
	if nextScenePath != null:
		get_tree().change_scene(nextScenePath)

func put_above( path ):
	if above_node != null:
		return
	get_tree().set_pause(true)
	above_node = load(path).instance()
	get_tree().get_root().add_child(above_node)

func clear_above():
	if above_node == null:
		return
	get_tree().set_pause(false)
	get_tree().get_root().remove_child(above_node)
	above_node = null

