extends RigidBody2D


func get_damages():
	return 15

func _on_body_entered(_body):
	queue_free()

func damage(_hitpoint):
	destroy()

func destroy():
	queue_free()
