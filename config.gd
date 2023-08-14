extends Node

const FILE_PATH = "user://1Bit-Sherprad.config"

var params = {
	"fullscreen": false
}

func _ready():
	load_config()

func _exit_tree():
	save_config()

func save_config():
	var cfg = FileAccess.open(FILE_PATH, FileAccess.WRITE)
	if cfg != null:
		cfg.store_var(params)

func load_config():
	var cfg = FileAccess.open(FILE_PATH, FileAccess.READ)
	if cfg != null:
		params = cfg.get_var()
	update_params()

func update(p, val):
	params[p] = val
	update_params()

func param(p):
	return params[p]

func update_params():
	if params.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
