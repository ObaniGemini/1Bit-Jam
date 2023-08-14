extends "res://scenes/main/level.gd"

const OFFSET = -100

var mega_times = 0

func _ready():
	$bg/LabelSpell/AudioStreamPlayer.finished.connect($AsteroidSpawnTimer.start)
	$Ship.set_camera_mode($Ship.Camera_Static)
	Music.play("level1")

func end_of_level():
	pass

func _on_asteroid_spawn_timer_timeout():
	var sc_ast = AsteroidFactory.random_asteroid(0.66)
	add_child(sc_ast)
	var rand_x = randf_range(OFFSET, 1280-OFFSET)
	sc_ast.position = Vector2(rand_x, OFFSET)


func _on_area_kill_asteroids_body_entered(body):
	if body.is_in_group("asteroid"):
		body.queue_free()


func _on_timer_before_mega_timeout():
	mega_times += 1
	var asteroids = AsteroidFactory.spawn_mega(mega_times)
	for i in range(len(asteroids)):
		# If 3 asteroids, will spawn on 1/4, 2/4, 3/4 of ~screen width
		var x_position = 100.0 + float(i + 1) / (mega_times + 1.0) * (1280 - 300)
		var asteroid = asteroids[i]
		asteroid.position = Vector2(x_position, OFFSET)
		add_child(asteroid)
		
	$TimerBeforeMega.wait_time = 15
	if mega_times < 3:
		$TimerBeforeMega.start()
	end_of_level()
