extends "res://scenes/main/level.gd"

const SKIP_TEXT = "Skipping."

@onready var skip_label = Label.new()
@onready var timer = Timer.new()
@onready var skip_timer = Timer.new()

var skipping = false
var idx = 0

func _ready():
	skip_label.text = ""
	skip_label.size = Vector2(1280, 720)
	skip_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	skip_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM 
	
	timer.wait_time = 0.75
	timer.timeout.connect(update_text)
	
	skip_timer.wait_time = 3.0
	skip_timer.autostart = false
	skip_timer.one_shot = false
	skip_timer.timeout.connect(finish)
	
	add_child(skip_label)
	add_child(timer)
	add_child(skip_timer)

func update_text():
	if skipping:
		skip_label.text = SKIP_TEXT
		var grad = float(idx % 2)
		skip_label.modulate = Color(grad, grad, grad)
		for i in range(idx):
			skip_label.text += "."
		idx = (idx + 1) % 4

func skip(s):
	skipping = s
	if skipping:
		timer.start()
		skip_timer.start()
		update_text()
	else:
		timer.stop()
		skip_timer.stop()
		skip_label.text = ""

func _input(event):
	if event.is_action_pressed("ui_accept"):
		skip(true)
	
	if event.is_action_released("ui_accept"):
		skip(false)
