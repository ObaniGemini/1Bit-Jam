extends "res://scenes/main/level.gd"


func _ready():
	$Ship.set_camera_mode($Ship.Camera_Follow)
