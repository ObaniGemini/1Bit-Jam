extends StaticBody2D


var life = 6

signal generator_destroyed

func destroy():
	generator_destroyed.emit()
	var t = get_tree().create_tween()
	t.tween_property($AnimationPlayer, "speed_scale", 0.0, 5.0)

func remove_shield():
	$Shield.queue_free()

func damage(hp):
	life -= hp
	if life <= 0:
		destroy()
