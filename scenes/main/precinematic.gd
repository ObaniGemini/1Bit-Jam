extends Node2D

const MENU_PATH = "res://scenes/main/menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.animation_finished.connect(load_menu)

func load_menu(_anim=""):
	get_tree().change_scene_to_file(MENU_PATH)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		load_menu()
