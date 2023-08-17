extends "res://scenes/main/level.gd"

const OFFSET = -512
const SPEED_SCALE = 8.0

var spawn_times = 0

func _ready():
	$Ship.set_camera_mode($Ship.Camera_Static)
	$Ship.arm[$Ship.Arm_Left].toggle_light()
	$Ship.arm[$Ship.Arm_Right].toggle_light()

@export var shake_amount = 0.0
func _process(_delta):
	$Camera2D.position = Vector2(shake_amount * (randf() - 0.5), shake_amount * (randf() - 0.5))

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




func _on_animation_player_animation_finished(anim_name):
	if anim_name == "ending":
		finish()
		print("finish")
		return
	
	$AsteroidSpawnTimer.stop()
	$AnimationPlayer.play("ending")
	print("You win!")
