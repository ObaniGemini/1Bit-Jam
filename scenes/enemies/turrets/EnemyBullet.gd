extends RigidBody2D


func get_damages():
	return 15

func _on_body_entered(body):
	queue_free()
