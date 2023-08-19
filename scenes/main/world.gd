extends Node2D

const MENU_PATH = "res://scenes/main/menu.tscn"
const LEVELS_PATH = "res://scenes/levels/" 
const GAME_OVER = preload("res://scenes/main/death_screen.tscn")

const LEVELS = [
	"controls",
	"cinematic_1",
	"Level1",
	"cinematic_2",
	"Level2",
	"Level3",
	"Level4",
	"Level5"
]

var level = -1;
var level_scene: Node = null

func _ready():
	next_level()
	$PauseMenu/menu/Fullscreen.pressed.connect($PauseMenu.set_fullscreen)
	$PauseMenu/menu/Menu.pressed.connect(go_to_menu)

func load_level():
	if level_scene != null:
		level_scene.queue_free() 
	level_scene = load(LEVELS_PATH + LEVELS[level] + ".tscn").instantiate()
	level_scene.finished.connect(next_level)
	if level_scene.has_signal("game_over"):
		level_scene.game_over.connect(game_over)
	call_deferred("add_child", level_scene)

func next_level():
	level += 1
	Entities.clear()
	
	if level_scene != null:
		level_scene.game_over.disconnect(game_over)
	
	if level == LEVELS.size():
		go_to_menu()
		return
	
	$Transition/AnimationPlayer.play("exit")
	await $Transition/AnimationPlayer.animation_finished
	
	load_level()
	$Transition/AnimationPlayer.play("enter")

func go_to_menu():
	$PauseMenu.set_pause(false)
	get_tree().change_scene_to_file(MENU_PATH)

func game_over():
	var node = GAME_OVER.instantiate()
	level_scene.queue_free()
	level_scene = node
	Entities.clear()
	add_child(level_scene)

#func _input(event):
#	if event.is_action_pressed("ui_end"):
#		next_level()
