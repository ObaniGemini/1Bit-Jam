extends CharacterBody2D

const SPEED = 50.0
const SPEED_INC = 2000.0

func _ready():
	velocity.y = -SPEED

func destroy():
	queue_free()

func _physics_process(delta):
	velocity.y -= SPEED_INC * delta
	move_and_slide()

func _on_timer_timeout():
	destroy()


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		### TODO, not just queue_free
		print("bullet")
		body.destroy()
		destroy()
