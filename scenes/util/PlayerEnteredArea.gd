extends Area2D

signal player_entered

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_entered.emit()
