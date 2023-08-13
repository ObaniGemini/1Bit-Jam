extends CharacterBody2D

const OPENED_POS = -440
const CLOSED_POS = OPENED_POS + 256

@export var opened = false

func anim(pos):
	var t = get_tree().create_tween()
	t.tween_property($door, "position:x", pos, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func open(): anim(OPENED_POS)
func close(): anim(CLOSED_POS)

func _ready():
	modulate = Color(0, 0, 0)
	
	if opened:
		$door.position.x = OPENED_POS
	else:
		$door.position.x = CLOSED_POS
