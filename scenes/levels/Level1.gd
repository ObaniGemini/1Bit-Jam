extends "res://scenes/main/level.gd"

const OFFSET = -20

func _ready():
	$Ship.set_camera_mode($Ship.Camera_Static)
	Music.play("level1")
