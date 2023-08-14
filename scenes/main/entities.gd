extends Node2D


func clear():
	for node in get_children():
		node.queue_free()
