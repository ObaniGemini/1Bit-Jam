extends CharacterBody2D

signal destroyed

func destroy():
	destroyed.emit()
	$Timer.stop()
	$Timer2.stop()
	$buttons.modulate = Color(0, 0, 0)

func flicker():
	var b = $buttons.get_children()
	for i in range(randi() % 5):
		var node = b.pick_random()
		var gradient = 1.0 - node.modulate.r
		node.modulate = Color(gradient, gradient, gradient)
