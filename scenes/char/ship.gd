extends CharacterBody2D

const bullet = preload("res://scenes/char/bullet.tscn")
const BULLET_OFFSET = 10
const CENTER = 640

const SHOOT_RELOAD = 3.0

const SPEED = 200.0
const ANGULAR_SPEED = 2.0
const JOYSTICK_MOVE_THRESHOLD = 0.1

signal player_died

var move_dir : Vector2 = Vector2(0, 0)

enum {
	Mode_Shoot,
	Mode_Light,
	
	Mode_Count
}

class ShootProperties:
	var parent
	var pos
	var timer
	
	func _init(holder, p):
		parent = holder
		pos = p
		
		timer = Timer.new()
		timer.autostart = false
		timer.one_shot = true
		timer.wait_time = SHOOT_RELOAD
		holder.add_child(timer)
	
	func shoot():
		if parent.mode == Mode_Shoot and timer.time_left <= 0.0 and !parent.get_node("light/AnimationPlayer").is_playing():
			timer.start()
			var b = bullet.instantiate()
			b.position = pos.global_position
			b.rotation = parent.rotation
			parent.get_parent().add_child(b)

enum {
	Shoot_Left,
	Shoot_Right
}

var mode = Mode_Shoot
@onready var shooter = [ShootProperties.new(self, $WeaponsPosition/Left), ShootProperties.new(self, $WeaponsPosition/Right)]

var angular_velocity = 0
var angular_accel = 0

func _ready():
	if $light.visible:
		$light.visible = false
	select_sprite()

func _process(_delta):
	$light.rotation = (position.x - CENTER) * -0.0005

func _physics_process(delta):
	velocity += move_dir * SPEED * delta
	angular_velocity += angular_accel * ANGULAR_SPEED * delta
	rotation += angular_velocity * delta
	
	move_and_slide()


func joy_axis_move(value):
	if abs(value) < JOYSTICK_MOVE_THRESHOLD: return 0.0
	return value

func switch():
	mode = (mode + 1) % Mode_Count
	select()
	select_sprite()

func select_sprite():
	$Sprite/VesselHeadLights.visible = mode == Mode_Light
	$Sprite/VesselWeapons.visible = mode != Mode_Light

func select():
	if mode == Mode_Light:
		$light/AnimationPlayer.play("on")
	else:
		$light/AnimationPlayer.play("off")

func _input(event):
	if event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_LEFT_X: move_dir.x = joy_axis_move(event.axis_value)
		elif event.axis == JOY_AXIS_LEFT_Y: move_dir.y = joy_axis_move(event.axis_value)
		
		if event.axis == JOY_AXIS_RIGHT_X: angular_accel = joy_axis_move(event.axis_value)
		
		if event.is_action_pressed("shoot_left"): shooter[Shoot_Left].shoot()
		if event.is_action_pressed("shoot_right"): shooter[Shoot_Right].shoot()
	else:
		if event.is_action_pressed("ui_left"): move_dir.x -= 1
		elif event.is_action_released("ui_left"): move_dir.x += 1
		if event.is_action_pressed("ui_right"): move_dir.x += 1
		elif event.is_action_released("ui_right"): move_dir.x -= 1

		if event.is_action_pressed("ui_up"): move_dir.y -= 1
		elif event.is_action_released("ui_up"): move_dir.y += 1
		if event.is_action_pressed("ui_down"): move_dir.y += 1
		elif event.is_action_released("ui_down"): move_dir.y -= 1
		
		if event.is_action_pressed("shoot_left"): shooter[Shoot_Left].shoot()
		if event.is_action_pressed("shoot_right"): shooter[Shoot_Right].shoot()
	
		if event.is_action_pressed("switch"): switch()
	
	move_dir.x = clampf(move_dir.x, -1, 1)
	move_dir.y = clampf(move_dir.y, -1, 1)

func kill():
	player_died.emit()


func _on_hitbox_receiver_body_entered(body):
	if body.is_in_group("asteroid"):
		kill()
	elif body.is_in_group("enemy"):
		kill()
