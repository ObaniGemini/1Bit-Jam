extends AudioStreamPlayer

@export var delay : float = 1.0


func delay_play():
	get_tree().create_timer(delay, true).timeout.connect(play)
