extends Area2D

signal selected
signal unselected
signal pressed

var is_selected = false
var disabled = false

var tween = null

func tween_btn(vec=Vector2(1, 1)):
	if(tween != null):
		tween.stop()
	
	var t = get_tree().create_tween().bind_node(self)
	t.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	t.tween_property(self, "scale", vec, randf_range(0.1, 0.3)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	tween = t

func default_tween():
	selected.connect(tween_btn.bind(Vector2(1.25, 1.25)))
	unselected.connect(tween_btn.bind())

func select():
	if visible && !is_selected:
		$AudioStreamPlayer2D.play()
		is_selected = true
		selected.emit()

func unselect():
	is_selected = false
	unselected.emit()
	for body in get_children():
		if body is Area2D:
			body.unselect()

func disable(b):
	disabled = b
	if disabled:
		mouse_entered.disconnect(select)
		mouse_exited.disconnect(unselect)
	else:
		mouse_entered.connect(select)
		mouse_exited.connect(unselect)

func _ready():
	disable(false)


func _input(event):
	if !is_selected or disabled:
		return
	
	if (event is InputEventMouseButton and event.pressed) or event.is_action_pressed("ui_accept"):
		pressed.emit()
