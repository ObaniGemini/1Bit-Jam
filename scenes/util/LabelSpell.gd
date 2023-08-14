extends Label

signal finished

@export var lifetime : float = 1.0
@export var wait_time : float = 30.0

const SPEED_MIN = 0.05
const SPEED_MAX = 0.15
var final_text = ""
var idx = 0

@onready var timer = Timer.new()
var alive_time = null

func _ready():
	timer.timeout.connect(next)
	add_child(timer)
	
	reset_text(text)

func reset_text(t):
	final_text = t
	text = ""
	idx = 0
	
	if lifetime > 0.0 and alive_time == null:
		alive_time = Timer.new()
		alive_time.timeout.connect(queue_free)
		alive_time.wait_time = lifetime + wait_time
		add_child(alive_time)
	
	if alive_time != null:
		alive_time.start()
	
	if wait_time == 0.0:
		next()
	else:
		timer.wait_time = wait_time
		timer.start()

func skip():
	text = final_text
	idx = final_text.length()
	$AudioStreamPlayer.play()
	finished.emit()

func next():
	if final_text.length() == idx:
		finished.emit()
		return
	
	text += final_text[idx]
	idx += 1
	timer.wait_time = randf_range(SPEED_MIN, SPEED_MAX)
	timer.start()
	$AudioStreamPlayer.play()
