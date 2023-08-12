extends CharacterBody2D

const SPEED = 1000.0

func _ready():
	velocity.y = -SPEED

func destroy():
	queue_free()

func _physics_process(delta):
	move_and_slide()

func _on_timer_timeout():
	destroy()


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		### TODO, not just queue_free
		body.queue_free()
		destroy()
