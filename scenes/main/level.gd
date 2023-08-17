extends Node2D

signal finished
signal game_over

func finish(_blank_arg=""):
	finished.emit()

func _on_ship_player_died():
	game_over.emit()

func end_of_level_animation(_animation):
	finished.emit()

func body_entered_end_level(body):
	if body.is_in_group("player"):
		finished.emit()
