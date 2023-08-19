extends Node2D

const TWEEN_TIME_MIN = 0.2
const TWEEN_TIME_MAX = 0.5

const WORLD_PATH = "res://scenes/main/world.tscn"

var selected = 1

var tween_play = [null, null]
var tween_fullscreen = [null, null, null, null, null]
var tween_quit = [null, null, null, null]

@onready var buttons = [$Fullscreen, $Play, $Quit]

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




func select_fullscreen():
	var basis = 0.0
	if Config.param("fullscreen"): basis += PI
	
	tween_btn(tween_fullscreen, 0, $Fullscreen/n/Sprite2D, "rotation", basis)
	tween_btn(tween_fullscreen, 1, $Fullscreen/n/Sprite2D2, "rotation", basis - (PI*3)/2)
	tween_btn(tween_fullscreen, 2, $Fullscreen/n/Sprite2D3, "rotation", basis + PI)
	tween_btn(tween_fullscreen, 3, $Fullscreen/n/Sprite2D4, "rotation", basis - PI/2)
	tween_btn(tween_fullscreen, 4, $Fullscreen/n, "scale", Vector2(1.25, 1.25))

func unselect_fullscreen():
	var basis = 0.0
	if Config.param("fullscreen"): basis += PI
	
	tween_btn(tween_fullscreen, 0, $Fullscreen/n/Sprite2D, "rotation", basis + PI)
	tween_btn(tween_fullscreen, 1, $Fullscreen/n/Sprite2D2, "rotation", basis - PI/2)
	tween_btn(tween_fullscreen, 2, $Fullscreen/n/Sprite2D3, "rotation", basis + PI*2)
	tween_btn(tween_fullscreen, 3, $Fullscreen/n/Sprite2D4, "rotation", basis - (PI * 3)/2)
	tween_btn(tween_fullscreen, 4, $Fullscreen/n, "scale", Vector2(1.0, 1.0))



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
	Entities.clear()
	Music.play("menu")
	unselect_fullscreen()
	
	$Fullscreen.pressed.connect(fullscreen)
	$Play.pressed.connect(play)
	$Quit.pressed.connect(quit)
	
	$Fullscreen.selected.connect(mouse_select.bind(0))
	$Play.selected.connect(mouse_select.bind(1))
	$Quit.selected.connect(mouse_select.bind(2))


func play():
	$Play.disable(true)
	$Fullscreen.hide()
	$Quit.hide()
	$shepard.hide()
	$to.hide()
	$the.hide()
	$void.hide()
	
	Music.play("wind")
	
	var t = get_tree().create_tween()
	t.tween_property($Play, "rotation", -PI/2, 0.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	t.tween_property($Play, "scale", Vector2(40, 40), 2.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_EXPO)
	
	await get_tree().create_timer(4.0, true).timeout
	
	get_tree().change_scene_to_file(WORLD_PATH)

func fullscreen():
	Config.update("fullscreen", !Config.param("fullscreen"))
	select_fullscreen()

func quit():
	print("Bye")
	get_tree().quit()

func _input(event):
	if event.is_action_pressed("ui_left"):
		select(-1)
	elif event.is_action_pressed("ui_right"):
		select(+1)

func mouse_select(i):
	if selected != i:
		buttons[selected].unselect()
		selected = i

func select(i):
	if (selected == 0 and i < 0) or (selected == (buttons.size() - 1) and i > 0):
		return
	
	if buttons[selected + i].visible:
		buttons[selected].unselect()
		selected += i
		buttons[selected].select()
