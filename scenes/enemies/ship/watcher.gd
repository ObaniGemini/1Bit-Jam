extends Area2D

@onready var speed = 200

var targets = []
var idx = 0
var tween = null

func destroy():
	queue_free()

func _ready():
	targets.append(position)
	
	for node in get_children():
		if node is Marker2D:
			targets.append(position + node.position)
	
	next()

func next():
	idx = (idx + 1) % targets.size()
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", targets[idx], position.distance_to(targets[idx]) / speed)
	tween.tween_callback(next)

func follow(player):
	$AudioStreamPlayer2D.pitch_scale = 16.0
	$Timer.timeout.connect(player.kill)

func unfollow(player):
	$AudioStreamPlayer2D.pitch_scale = 1.0
	$Timer.timeout.disconnect(player.kill)

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.kill()
		follow(body)


func _on_body_exited(body):
	if body.is_in_group("player"):
		unfollow(body)
