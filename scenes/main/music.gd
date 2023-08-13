extends Node

const TWEEN_TIME = 5.0
const MIN_DB = -40

var playing = null

func play(sound):
	if playing != null:
		var t = get_tree().create_tween().bind_node(playing)
		t.tween_property(playing, "volume_db", MIN_DB, TWEEN_TIME).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
		t.tween_callback(playing.stop)
	
	if has_node(sound):
		playing = get_node(sound)
		playing.volume_db = MIN_DB
		var t = get_tree().create_tween().bind_node(playing)
		t.tween_property(playing, "volume_db", 0, TWEEN_TIME).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
		playing.play()
	else:
		print("Music '" + sound + "' isn't in the game!")
