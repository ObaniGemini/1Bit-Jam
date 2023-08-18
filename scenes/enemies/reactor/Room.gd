extends Node2D

signal room_cleared

var num_destroyed = 0
@onready var num_to_destroy = $to_explode.get_child_count()

func _ready():
	$CollisionPolygon2D/LightOccluder2D/Sprite2D.modulate = Color(0, 0, 0)
	$CollisionPolygon2D2/LightOccluder2D/Sprite2D.modulate = Color(0, 0, 0)
	for node in $to_explode.get_children():
		node.destroyed.connect(_on_console_destroyed)

func _on_console_destroyed():
	num_destroyed += 1
	if num_destroyed == num_to_destroy:
		room_cleared.emit()
