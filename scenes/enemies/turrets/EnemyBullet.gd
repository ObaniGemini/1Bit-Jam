extends RigidBody2D


func get_damages():
	return 15

func _on_body_entered(_body):
	queue_free()
