extends RigidBody2D

const SPEED = 100.0
const SPEED_INC = 4.0

func _ready():
	linear_velocity = SPEED * Vector2(sin(rotation), -cos(rotation))
	$shoot.play()

func destroy():
	set_physics_process(false)
	collision_layer = 0
	collision_mask = 0
	
	$AnimationPlayer.play("explode")
	for body in $ExplodeArea.get_overlapping_bodies():
		print(body)
		if body.is_in_group("destroyable"):
			body.destroy()
		elif body.is_in_group("enemy"):
			body.damage(1)

func _physics_process(delta):
	linear_velocity *= 1.0 + SPEED_INC * delta

func _on_timer_timeout():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("player"):
		return
	
	disconnect("body_entered", _on_body_entered)
	destroy()
