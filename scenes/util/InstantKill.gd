extends Area2D


func _ready():
	body_entered.connect(body_enter)

func body_enter(body):
	if body.is_in_group("player"):
		body.damage(200)
