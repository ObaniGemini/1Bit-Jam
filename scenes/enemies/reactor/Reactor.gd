extends StaticBody2D


var life = 10

signal reactor_destroyed

func _ready():
	$OuterShield.modulate = Color(0, 0, 0)
	$InnerShield.modulate = Color(0, 0, 0)

func destroy():
	reactor_destroyed.emit()
	queue_free()

func remove_outer_shield():
	$OuterShield.queue_free()

func remove_inner_shield():
	$InnerShield.queue_free()


func damage(hp):
	life -= hp
	if life <= 0:
		destroy()
