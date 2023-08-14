extends AudioStreamPlayer

@export var delay : float = 1.0


func play_delayed():
	get_tree().create_timer(delay, true).timeout.connect(play)
