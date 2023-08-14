extends CharacterBody2D

signal destroyed

var dead = false

func destroy():
	if dead:
		return
	
	dead = true
	destroyed.emit()
	$Timer.stop()
	$Timer2.stop()
	$buttons.modulate = Color(0, 0, 0)
	$AudioStreamPlayer2D.stop()

func flicker():
	var b = $buttons.get_children()
	for i in range(randi() % 5):
		var node = b.pick_random()
		var gradient = 1.0 - node.modulate.r
		node.modulate = Color(gradient, gradient, gradient)
