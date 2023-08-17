extends Area2D


func explode():
	body_entered.connect(body_enter)
	for body in get_overlapping_bodies():
		body_enter(body)
	
	$GPUParticles2D.emitting = true
	$GPUParticles2D2.emitting = true
	$GPUParticles2D3.emitting = true
	$AudioStreamPlayer2D.playing = true

func body_enter(body):
	if body.is_in_group("player"):
		body.damage(200)
