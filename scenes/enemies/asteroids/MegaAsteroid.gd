extends "res://scenes/enemies/asteroids/Asteroid.gd"


# Called when the node enters the scene tree for the first time.
func _ready():
	var turrets = $Turrets.get_children()
	
	for _i in range(randi() % turrets.size()):
		turrets.pick_random().queue_free()
	
	turrets = $Turrets.get_children()
	for turret in turrets:
		add_collision_exception_with(turret)
	
	init()

