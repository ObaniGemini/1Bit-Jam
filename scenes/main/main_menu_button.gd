extends Area2D

signal selected
signal unselected
signal pressed

var is_selected = false
var disabled = false

func select():
	if visible && !is_selected:
		$AudioStreamPlayer2D.play()
		is_selected = true
		emit_signal("selected")

func unselect():
	is_selected = false
	emit_signal("unselected")
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
	
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("pressed")
	
	if event.is_action_pressed("ui_accept"):
		emit_signal("pressed")
