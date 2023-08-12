extends Node2D

const MENU_PATH = "res://scenes/main/menu.tscn"
const LEVELS_PATH = "res://scenes/levels/" 
const GAME_OVER = preload("res://scenes/main/death_screen.tscn")

const LEVELS = [
	"cinematic_1",
	"Level1"
]

var level = -1;
var level_scene = null

func _ready():
	next_level()

func load_level():
	if level_scene != null:
		level_scene.queue_free() 
	level_scene = load(LEVELS_PATH + LEVELS[level] + ".tscn").instantiate()
	level_scene.finished.connect(next_level)
	add_child(level_scene)

func next_level():
	level += 1
	if level == LEVELS.size():
		get_tree().change_scene_to_file(MENU_PATH)
		return
	
	load_level()

func game_over():
	var node = GAME_OVER.instantiate()
	level_scene.queue_free()
	level_scene = node
	add_child(level_scene)
