extends "res://scenes/main/level.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Ship.set_camera_mode($Ship.Camera_Follow)
	
	for c in $WorldBoundary.get_children():
		var n = c.get_child(0)
		n.scale = c.shape.size
		n.modulate = Color(0, 0, 0)

