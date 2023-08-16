extends Area2D

signal player_entered

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_entered.emit()
		body_entered.disconnect(_on_body_entered)
