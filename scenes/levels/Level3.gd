extends "res://scenes/main/level.gd"

func _ready():
	$Ship.set_camera_mode($Ship.Camera_Follow)


# Detect right room is finished to unlock right generator
# Same for left room

# Pipeline :
# 1. R/L Room is destroyed
# 2. Unlocks generators (remove shield)
# 3. Generator 1 destroyed -> remove first reactor shield
# 4. Generator 2 destroyed -> remove second reactor shield
# 5. Reactor is exposed and can be destroyed
