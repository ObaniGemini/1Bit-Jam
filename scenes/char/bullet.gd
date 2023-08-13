extends CharacterBody2D

const SPEED = 100.0
const SPEED_INC = 4.0

func _ready():
	velocity = SPEED * Vector2(sin(rotation), -cos(rotation))
	$shoot.play()

func destroy():
	set_physics_process(false)
	$AnimationPlayer.play("explode")
	for body in $ExplodeArea.get_overlapping_bodies():
		if body.is_in_group("enemy") or body.is_in_group("destroyable"):
			body.destroy()

func _physics_process(delta):
	velocity *= 1.0 + SPEED_INC * delta
	move_and_slide()

func _on_timer_timeout():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		return
	
	$Area2D.disconnect("body_entered", _on_area_2d_body_entered)
	destroy()
