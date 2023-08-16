extends StaticBody2D


func remove_outer_shield():
	$OuterShield.queue_free()

func remove_inner_shield():
	$InnerShield.queue_free()


func damage(hp):
	pass
