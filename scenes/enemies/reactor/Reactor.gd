extends StaticBody2D

signal reactor_destroyed

const DMG_PER_DISTANCE = 2000.0
var num_shields = 2
var life = 16

var ship = null

func _ready():
	$OuterShield.modulate = Color(0, 0, 0)
	$InnerShield.modulate = Color(0, 0, 0)
	remove_outer_shield()
	remove_inner_shield()

func destroy():
	reactor_destroyed.emit()
	queue_free()

func check_process():
	if num_shields <= 0:
		set_physics_process(true)

func remove_outer_shield():
	num_shields -= 1
	$OuterShield.queue_free()
	check_process()

func remove_inner_shield():
	num_shields -= 1
	$InnerShield.queue_free()
	check_process()

func _physics_process(delta):
	print((DMG_PER_DISTANCE/float(1 + ship.position.distance_to(position))))
	ship.damage(delta * (DMG_PER_DISTANCE/(1.0 + ship.position.distance_to(position))))


func damage(hp):
	life -= hp
	if life <= 0:
		destroy()
