extends "res://scenes/main/level.gd"

const OFFSET = -512
const SPEED_SCALE = 2.0

var spawn_times = 0
var mega_times = 0

func _ready():
	$fg/LabelSpell/AudioStreamPlayer.finished.connect($TimerBeforeMega.start)
	$Ship.set_camera_mode($Ship.Camera_Static)
	Music.play("level1")

func compute_big_proba():
	return clampf(-spawn_times * 0.025 + 0.5, 0, 0.5)

func _on_asteroid_spawn_timer_timeout():
	spawn_times += 1
	
	var big_proba = compute_big_proba()
	var sc_ast = AsteroidFactory.random_asteroid(big_proba, SPEED_SCALE)
	add_child(sc_ast)
	
	sc_ast.position = Vector2(randf_range(0, 1280), OFFSET)


func _on_area_kill_asteroids_body_entered(body):
	if body.is_in_group("asteroid"):
		body.queue_free()




func _on_animation_player_animation_finished(_anim_name):
	$AsteroidSpawnTimer.stop()
	print("You win!")
