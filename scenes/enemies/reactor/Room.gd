extends Node2D

signal room_cleared

var nb_console_destroyed = 0


func destroy_room():
	# Room destruction animation ?
	room_cleared.emit()
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if nb_console_destroyed == 3:
		destroy_room()
		nb_console_destroyed = -1

func _on_console_destroyed():
	nb_console_destroyed += 1
