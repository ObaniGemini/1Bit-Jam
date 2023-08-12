extends Node2D

const TWEEN_TIME_MIN = 0.1
const TWEEN_TIME_MAX = 0.4

const WORLD_PATH = "res://scenes/main/world.tscn"

var selected = null

func t_time():
	return randf_range(TWEEN_TIME_MIN, TWEEN_TIME_MAX)

func tween_btn(obj, prop, pos):
	var t = get_tree().create_tween().bind_node(self)
	t.tween_property(obj, prop, pos, randf_range(TWEEN_TIME_MIN, TWEEN_TIME_MAX)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)




func select_play():
	tween_btn($Play/Sprite2D, "position:y", -80)
	tween_btn($Play/Sprite2D2, "position:y", 80)

func unselect_play():
	tween_btn($Play/Sprite2D, "position:y", -64)
	tween_btn($Play/Sprite2D2, "position:y", 64)




func select_settings():
	tween_btn($Settings/Sprite2D, "position:y", -256)
	tween_btn($Settings/Sprite2D2, "position:y", 256)

func unselect_settings():
	tween_btn($Settings/Sprite2D, "position:y", -64)
	tween_btn($Settings/Sprite2D2, "position:y", 64)




func select_quit():
	tween_btn($Quit/Node2D/Sprite2D, "position:y", 24)
	tween_btn($Quit/Node2D/Sprite2D2, "position:y", -24)
	tween_btn($Quit/Node2D/Sprite2D3, "position:x", -24)
	tween_btn($Quit/Node2D/Sprite2D4, "position:x", 24)

func unselect_quit():
	tween_btn($Quit/Node2D/Sprite2D, "position:y", 0)
	tween_btn($Quit/Node2D/Sprite2D2, "position:y", 0)
	tween_btn($Quit/Node2D/Sprite2D3, "position:x", 0)
	tween_btn($Quit/Node2D/Sprite2D4, "position:x", 0)




func _ready():
	$Play.pressed.connect(play)
	$Play.selected.connect($Settings.unselect)
	$Play.selected.connect($Quit.unselect)
	
#	$Settings.pressed.connect(quit)
	$Settings.selected.connect($Play.unselect)
	$Settings.selected.connect($Quit.unselect)
	
	$Quit.pressed.connect(quit)
	$Quit.selected.connect($Play.unselect)
	$Quit.selected.connect($Settings.unselect)




func play():
	get_tree().change_scene_to_file(WORLD_PATH)

func quit():
	print("Bye")
	get_tree().quit()
