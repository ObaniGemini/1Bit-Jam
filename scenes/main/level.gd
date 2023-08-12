extends Node2D

signal finished

func finish():
	emit_signal("finished")
