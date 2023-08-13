extends CharacterBody2D

const SPEED = 100.0
const SPEED_INC = 4.0

func _ready():
	velocity = SPEED * Vector2(sin(rotation), -cos(rotation))

func destroy():
	queue_free()

func _physics_process(delta):
	velocity *= 1.0 + SPEED_INC * delta
	move_and_slide()

func _on_timer_timeout():
	destroy()


func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy"):
		body.destroy()
		destroy()
