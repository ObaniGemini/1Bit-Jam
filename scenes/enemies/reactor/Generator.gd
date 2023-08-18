extends StaticBody2D


var life = 6

signal generator_destroyed

func destroy():
	generator_destroyed.emit()

func remove_shield():
	$Shield.queue_free()

func damage(hp):
	life -= hp
	if life <= 0:
		destroy()
