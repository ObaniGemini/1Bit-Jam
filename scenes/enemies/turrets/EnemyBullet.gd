extends RigidBody2D


func get_damages():
	return 15

func _on_body_entered(_body):
	destroy()

func damage(_hitpoint):
	destroy()

func destroy():
	collision_layer = 0
	collision_mask = 0
	$Node2D/AnimationPlayer.play("explode")
