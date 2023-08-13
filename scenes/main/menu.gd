extends Node2D

const TWEEN_TIME_MIN = 0.1
const TWEEN_TIME_MAX = 0.4

const WORLD_PATH = "res://scenes/main/world.tscn"

var selected = 1

@onready var tween_play = [null, null]
@onready var tween_settings = [null, null]
@onready var tween_quit = [null, null, null, null]

@onready var buttons = [$Settings, $Play, $Quit]

func tween_btn(array, idx, node, prop, pos):
	if(array[idx] != null):
		array[idx].stop()
	
	var t = node.create_tween()
	t.tween_property(node, prop, pos, randf_range(TWEEN_TIME_MIN, TWEEN_TIME_MAX)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	array[idx] = t


func select_play():
	tween_btn(tween_play, 0, $Play/Sprite2D, "position:y", -80)
	tween_btn(tween_play, 1, $Play/Sprite2D2, "position:y", 80)

func unselect_play():
	tween_btn(tween_play, 0, $Play/Sprite2D, "position:y", -64)
	tween_btn(tween_play, 1, $Play/Sprite2D2, "position:y", 64)




func select_settings():
	tween_btn(tween_settings, 0, $Settings/Sprite2D, "position:y", -220)
	tween_btn(tween_settings, 1, $Settings/Sprite2D2, "position:y", 220)

func unselect_settings():
	tween_btn(tween_settings, 0, $Settings/Sprite2D, "position:y", -64)
	tween_btn(tween_settings, 1, $Settings/Sprite2D2, "position:y", 64)




func select_quit():
	tween_btn(tween_quit, 0, $Quit/Node2D/Sprite2D, "position:y", 24)
	tween_btn(tween_quit, 1, $Quit/Node2D/Sprite2D2, "position:y", -24)
	tween_btn(tween_quit, 2, $Quit/Node2D/Sprite2D3, "position:x", -24)
	tween_btn(tween_quit, 3, $Quit/Node2D/Sprite2D4, "position:x", 24)

func unselect_quit():
	tween_btn(tween_quit, 0, $Quit/Node2D/Sprite2D, "position:y", 0)
	tween_btn(tween_quit, 1, $Quit/Node2D/Sprite2D2, "position:y", 0)
	tween_btn(tween_quit, 2, $Quit/Node2D/Sprite2D3, "position:x", 0)
	tween_btn(tween_quit, 3, $Quit/Node2D/Sprite2D4, "position:x", 0)




func _ready():
	$Play.pressed.connect(play)
	
#	$Settings.pressed.connect(quit)
	
	$Quit.pressed.connect(quit)



func play():
	$Play.disable(true)
	$Settings.hide()
	$Quit.hide()
	
	$Play/start.play()
	
	var t = get_tree().create_tween()
	t.tween_property($Play, "rotation", -PI/2, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	t.tween_property($Play, "scale", Vector2(40, 40), 2.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	
	await get_tree().create_timer(4.0, true).timeout
	
	get_tree().change_scene_to_file(WORLD_PATH)

func quit():
	print("Bye")
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("ui_left"):
		select(-1)
	elif event.is_action_pressed("ui_right"):
		select(+1)

func select(i):
	if (selected == 0 and i < 0) or (selected == (buttons.size() - 1) and i > 0):
		return
	
	if buttons[selected + i].visible:
		buttons[selected].unselect()
		selected += i
		buttons[selected].select()
