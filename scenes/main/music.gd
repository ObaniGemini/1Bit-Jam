extends Node

func play(sound):
	if has_node(sound):
		get_node(sound).play()
	else:
		print("Music '" + sound + "' isn't in the game!")
