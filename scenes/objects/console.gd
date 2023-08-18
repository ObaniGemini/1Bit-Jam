extends CharacterBody2D

signal destroyed

@export var dead = false

func _ready():
	add_to_group("destroyable")
	
	$Timer.timeout.connect(flicker)
	$Timer2.timeout.connect(flicker)
	
	if dead: stop()
	else:
		$Timer.start()
		$Timer2.start()

func stop():
	destroyed.emit()
	$Timer.stop()
	$Timer2.stop()
	$buttons.queue_free()
	$AudioStreamPlayer2D.stop()

func destroy():
	if dead:
		return
	
	dead = true
	stop()

func flicker():
	var b = $buttons.get_children()
	for i in range(randi() % 5):
		var node = b.pick_random()
		var gradient = 1.0 - node.modulate.r
		node.modulate = Color(gradient, gradient, gradient)
