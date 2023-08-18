extends StaticBody2D

signal reactor_destroyed

const DMG_PER_DISTANCE = 2000.0
var num_shields = 2
var life = 16

var ship = null

func _ready():
	set_physics_process(false)
	$OuterShield.modulate = Color(0, 0, 0)
	$InnerShield.modulate = Color(0, 0, 0)

var dead = false
func destroy():
	if dead:
		return
	
	dead = true
	reactor_destroyed.emit()
	$AudioStreamPlayer2D.stop()
	$AudioStreamPlayer2D2.stop()
	$down.play()
	$explode.play()
	$GPUParticles2D.emitting = true
	$GPUParticles2D2.emitting = true
	$GPUParticles2D3.emitting = true
	set_physics_process(false)

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
	ship.damage(delta * (DMG_PER_DISTANCE/(1.0 + ship.position.distance_to(position))))


func damage(hp):
	life -= hp
	if life <= 0:
		destroy()
