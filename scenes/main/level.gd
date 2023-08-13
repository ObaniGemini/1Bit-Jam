extends Node2D

signal finished
signal game_over

func finish():
	emit_signal("finished")
