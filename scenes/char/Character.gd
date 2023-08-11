extends CharacterBody2D


const SPEED = 300.0
const JOYSTICK_MOVE_THRESHOLD = 0.1
const JOYSTICK_SHOOT_THRESHOLD = 0.15
const JOYSTICK_SHOOT_MIN_LENGTH = 0.6

var move_dir : Vector2 = Vector2(0, 0)
var shoot_dir : Vector2 = Vector2(0, 0)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	debug_log()
	velocity = move_dir * SPEED
	move_and_slide()

func joy_axis_move(value):
	if abs(value) < JOYSTICK_MOVE_THRESHOLD: return 0.0
	return value

func dbg_vec(vec):
	return str(floorf(vec.x * 100)/100.0) + ", " + str(floorf(vec.y * 100)/100.0)

func debug_log():
	$Debug/VBoxContainer/HBoxContainer/MoveDir.text = dbg_vec(move_dir)
	$Debug/VBoxContainer/HBoxContainer2/Pos.text = dbg_vec(position)

func _input(event):
	if event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_LEFT_X: move_dir.x = joy_axis_move(event.axis_value)
		elif event.axis == JOY_AXIS_LEFT_Y: move_dir.y = joy_axis_move(event.axis_value)
	else:
		if event.is_action_pressed("ui_left"): move_dir.x -= 1
		elif event.is_action_released("ui_left"): move_dir.x += 1
		if event.is_action_pressed("ui_right"): move_dir.x += 1
		elif event.is_action_released("ui_right"): move_dir.x -= 1

		if event.is_action_pressed("ui_up"): move_dir.y -= 1
		elif event.is_action_released("ui_up"): move_dir.y += 1
		if event.is_action_pressed("ui_down"): move_dir.y += 1
		elif event.is_action_released("ui_down"): move_dir.y -= 1
	
	move_dir.x = clampf(move_dir.x, -1, 1)
	move_dir.y = clampf(move_dir.y, -1, 1)
	shoot_dir.x = clampf(shoot_dir.x, -1, 1)
	shoot_dir.y = clampf(shoot_dir.y, -1, 1)
