extends "res://scenes/main/level.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Ship.set_camera_mode($Ship.Camera_Follow)
	$TileMap.modulate = Color(0, 0, 0)
