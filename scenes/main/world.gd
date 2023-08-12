extends Node2D

const MENU_PATH = "res://scenes/main/menu.tscn"
const LEVELS_PATH = "res://scenes/levels/" 

const LEVELS = ["Level1"]

var current_idx = 0;
var level = null

func _ready():
	next_level()

func next_level():
	if current_idx == LEVELS.size():
		get_tree().change_scene_to_file(MENU_PATH)
		return
	
	if level != null:
		level.queue_free() 
	level = load(LEVELS_PATH + LEVELS[current_idx] + ".tscn").instantiate()
	level.finished.connect(next_level)
	add_child(level)
	
	current_idx += 1
