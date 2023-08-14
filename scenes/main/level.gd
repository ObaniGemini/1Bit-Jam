extends Node2D

signal finished
signal game_over

func finish(_blank_arg=""):
	emit_signal("finished")

func _on_ship_player_died():
	game_over.emit()
