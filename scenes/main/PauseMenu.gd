extends CanvasLayer


var paused = false
func set_pause(p):
	paused = p
	get_tree().paused = p
	
	visible = p
	$menu/Fullscreen.disable(!p)
	$menu/Menu.disable(!p)

func set_fullscreen():
	Config.update("fullscreen", !Config.param("fullscreen"))
	if Config.param("fullscreen"):
		$menu/Fullscreen/Label.text = "Windowed"
	else:
		$menu/Fullscreen/Label.text = "Fullscreen"

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		set_pause(!paused)
	elif event.is_action_pressed("ui_left"):
		$menu/Menu.unselect()
		$menu/Fullscreen.select()
	elif event.is_action_pressed("ui_right"):
		$menu/Fullscreen.unselect()
		$menu/Menu.select()

func _ready():
	$menu/Fullscreen.default_tween()
	$menu/Menu.default_tween()
	set_pause(false)
