extends GPUParticles2D


func set_force(i):
	amount = i
	$Explosion.amount = i
	$Explosion2.amount = i
	lifetime = 0.25 + float(i)/32.0
	$Timer.wait_time = lifetime
