extends CharacterBody2D

const bullet = preload("res://scenes/char/bullet.tscn")
const BULLET_OFFSET = 10


const SPEED = 250.0
const JOYSTICK_MOVE_THRESHOLD = 0.1

var move_dir : Vector2 = Vector2(0, 0)
var shooting = false

enum {
	Mode_Shoot,
	Mode_Light,
	
	Mode_Count
}

var mode = Mode_Shoot

func _ready():
	if $light.visible:
		$light.visible = false
	select_sprite(mode)

func _physics_process(delta):
	velocity = move_dir * SPEED
	
	shoot()
	move_and_slide()

func shoot():
	if shooting and mode == Mode_Shoot and $shoot_delay.time_left <= 0.0 and !$light/AnimationPlayer.is_playing():
		$shoot_delay.start()
		var b1 = bullet.instantiate()
		var b2 = bullet.instantiate()
		
		b1.position = $WeaponsPosition/Left.global_position
		b2.position = $WeaponsPosition/Right.global_position
		get_parent().add_child(b1)
		get_parent().add_child(b2)


func joy_axis_move(value):
	if abs(value) < JOYSTICK_MOVE_THRESHOLD: return 0.0
	return value

func switch():
	mode = (mode + 1) % Mode_Count
	select(mode)
	select_sprite(mode)

func select_sprite(mode):
	$Sprite/VesselHeadLights.visible = mode == Mode_Light
	$Sprite/VesselWeapons.visible = mode != Mode_Light

func select(mode):
	if mode == Mode_Light:
		$light/AnimationPlayer.play("on")
	else:
		$light/AnimationPlayer.play("off")

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
		
		if event.is_action_pressed("shoot"): shooting = true
		elif event.is_action_released("shoot"): shooting = false
	
		if event.is_action_pressed("switch"): switch()
	
	move_dir.x = clampf(move_dir.x, -1, 1)
	move_dir.y = clampf(move_dir.y, -1, 1)

