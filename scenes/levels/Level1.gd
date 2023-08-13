extends "res://scenes/main/level.gd"

const OFFSET = -20

func _ready():
	$LabelSpell/AudioStreamPlayer.finished.connect($AsteroidSpawnTimer.start)
	$Ship.set_camera_mode($Ship.Camera_Static)
	Music.play("level1")

func _on_asteroid_spawn_timer_timeout():
	var sc_ast = AsteroidFactory.random_asteroid(0.66)
	add_child(sc_ast)
	var rand_x = randf_range(OFFSET, 1280-OFFSET)
	sc_ast.position = Vector2(rand_x, OFFSET)


func _on_area_kill_asteroids_body_entered(body):
	if body.is_in_group("asteroid"):
		body.queue_free()
