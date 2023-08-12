extends Label

@export var lifetime : float = 1.0

const SPEED_MIN = 0.05
const SPEED_MAX = 0.15
var final_text = ""
var idx = 0

@onready var timer = Timer.new()
@onready var alive_time = Timer.new()

func _ready():
	final_text = text
	text = ""
	
	timer.timeout.connect(next)
	add_child(timer)
	
	alive_time.timeout.connect(queue_free)
	alive_time.wait_time = lifetime
	alive_time.autostart = true
	add_child(alive_time)
	
	next()

func next():
	if final_text.length() == idx:
		return
	
	text += final_text[idx]
	idx += 1
	timer.wait_time = randf_range(SPEED_MIN, SPEED_MAX)
	timer.start()
