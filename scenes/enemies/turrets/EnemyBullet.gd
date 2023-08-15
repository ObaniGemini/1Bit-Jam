extends RigidBody2D

func _on_body_entered(body):
	if body.is_in_group("enemy"):
		body.damage(1)
	elif body.is_in_group("player"):
		body.damage(15)
	destroy()

func damage(_hitpoint):
	destroy()

func destroy():
	collision_layer = 0
	collision_mask = 0
	$Node2D/AnimationPlayer.play("explode")
