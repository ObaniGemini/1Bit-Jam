extends "res://scenes/main/level.gd"


const TIMER_EXPLOSION = 60.0
var explosions = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$Ship.set_camera_mode($Ship.Camera_Follow)
	$TileMap.modulate = Color(0, 0, 0)
	$explosions/Timer.wait_time = TIMER_EXPLOSION
	$explosions/Timer.one_shot = true
	$explosions/Timer.start()
	$explosions/Timer.timeout.connect(explode)
	
	for node in $explosions.get_children():
		if node is Area2D:
			explosions.append(node)

func explode():
	if explosions.size() == 0:
		return
	
	explosions.pop_front().explode()
	$AnimationPlayer.play("screenshake")
	$explosions/Timer.wait_time = 0.1
	$explosions/Timer.start()
