extends "res://scenes/main/level.gd"

const OFFSET = -256
const OFFSET_MEGA = -512

var spawn_times = 0
var mega_times = 0

func _ready():
	$fg/LabelSpell/AudioStreamPlayer.finished.connect($TimerBeforeMega.start)
	$Ship.set_camera_mode($Ship.Camera_Static)
	Music.play("level1")

func compute_big_proba():
	return clampf(spawn_times * 0.05 + 0.05, 0, 0.5)

func _on_asteroid_spawn_timer_timeout():
	spawn_times += 1
	var num_asteroids = 1 + spawn_times/50
	for i in range(num_asteroids):
		var big_proba = compute_big_proba()
		var sc_ast = AsteroidFactory.random_asteroid(big_proba)
		add_child(sc_ast)
		
		var x_range = 1280/num_asteroids
		var rand_x = randf_range(0, x_range) + i * x_range
		sc_ast.position = Vector2(rand_x, OFFSET)


func _on_area_kill_asteroids_body_entered(body):
	if body.is_in_group("asteroid"):
		body.queue_free()


func _on_timer_before_mega_timeout():
	mega_times += 1
	var asteroids = AsteroidFactory.spawn_mega(min(mega_times, 2))
	var rand_pos_x = (randf_range(0, 1280/len(asteroids) - 200.0) + 100.0)
	for i in range(asteroids.size()):
		# If 3 asteroids, will spawn on 1/4, 2/4, 3/4 of ~screen width
		var asteroid = asteroids[i]
		asteroid.position = Vector2(float(i + 1) * rand_pos_x, OFFSET_MEGA)
		Entities.add_child(asteroid)
	
	$TimerBeforeMega.wait_time = 30
	$TimerBeforeMega.start()


func _on_speed_increase_timeout():
	$AsteroidSpawnTimer.wait_time -= 0.01
