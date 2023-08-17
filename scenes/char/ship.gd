extends CharacterBody2D

signal player_died

const bullet = preload("res://scenes/char/bullet.tscn")
const BULLET_OFFSET = 10
const CENTER = 640

const SHOOT_RELOAD = 3.0

const SPEED = 250.0
const ANGULAR_SPEED = 4.0
const ANGULAR_DAMPING = 0.375
const JOYSTICK_MOVE_THRESHOLD = 0.1

var move_dir : Vector2 = Vector2(0, 0)

const BULLET_ENERGY = 40.0
const LIGHT_ENERGY = 3.0
const RECOVER_ENERGY = 20.0
const LOW_ENERGY = 10.0

class ArmProperties:
	var parent
	var handler
	var progressbar
	var light_on
	var light
	var anim
	var timer
	var rot
	
	func _init(holder, h, pb):
		parent = holder
		handler = h
		progressbar = pb
		progressbar.value = 100
		light_on = false
		anim = handler.get_node("AnimationPlayer")
		light = handler.get_node("Sprite2D")
		rot = light.rotation
		
		timer = Timer.new()
		timer.one_shot = true
		timer.autostart = false
		timer.wait_time = 0.25
		parent.add_child(timer)
	
	func shoot():
		if timer.time_left <= 0.0:
			if progressbar.value < BULLET_ENERGY:
				progressbar.get_node("blink").play("blink")
				return
			
			timer.start()
			progressbar.value -= BULLET_ENERGY
			
			var b = bullet.instantiate()
			b.position = handler.global_position
			b.rotation = parent.rotation
			b.add_collision_exception_with(parent)
			Entities.add_child(b)
	
	func toggle_light():
		light_on = !light_on
		
		anim.speed_scale = 1.0
		if light_on: anim.play("on")
		else: anim.play("off")
	
	func process(delta, accel):
		light.rotation = rot + accel * 0.1
		
		if light_on:
			progressbar.value -= LIGHT_ENERGY * delta
			if progressbar.value <= 0.0: toggle_light()
			elif progressbar.value < LOW_ENERGY and anim.current_animation != "weak":
				anim.speed_scale = randf_range(0.75, 1.5)
				anim.play("weak")
		else:
			progressbar.value += RECOVER_ENERGY * delta


enum {
	Arm_Left,
	Arm_Right
}

enum {
	Camera_Static,
	Camera_Follow
}

var camera_mode = Camera_Static
@onready var arm = [ArmProperties.new(self, $WeaponsPosition/Left, $UI/shoot_left), ArmProperties.new(self, $WeaponsPosition/Right, $UI/shoot_right)]

const MAX_HEALTH = 100.0
const WARNING_HEALTH = 30.0

var angular_velocity = 0
var angular_accel = 0
var health = MAX_HEALTH

@export var low_booster_active = false
@export var strong_booster_active = false

func _ready():
	$boosters.visible = true
	$rotaters.visible = true
	$WeaponsPosition/Left/Sprite2D.visible = false
	$WeaponsPosition/Right/Sprite2D.visible = false
	update_smoke()

var health_tween = null
func damage(d):
	var previous_health = health
	health -= d
	
	if health <= 0.0:
		kill()
	elif previous_health > WARNING_HEALTH and health <= WARNING_HEALTH:
		$UI/HealthCritical.play()
	
	$UI/health_bar/left.value = health
	$UI/health_bar/right.value = health

func set_camera_mode(m):
	camera_mode = m 
	$Camera2D.enabled = camera_mode == Camera_Follow

func heatlh_glitch():
	$UI/health_bar/Timer.wait_time = randf_range(20.0, 90.0)
	$UI/health_bar/Timer.start()
	$UI/health_bar/glitch.play("bug")

var previous_velocity = Vector2()
func _physics_process(delta):
	previous_velocity = velocity
	
	var vel = move_dir * SPEED * delta
	if camera_mode == Camera_Follow:
		vel = vel.rotated(rotation)
	
	
	velocity += vel
	angular_velocity += angular_accel * ANGULAR_SPEED * delta
	angular_velocity -= signf(angular_velocity) * ANGULAR_DAMPING * delta
	rotation += angular_velocity * delta
	
	arm[Arm_Left].process(delta, angular_velocity)
	arm[Arm_Right].process(delta, angular_velocity)
	
	move_and_slide()
	velocity = get_real_velocity()


func joy_axis_move(value):
	if abs(value) < JOYSTICK_MOVE_THRESHOLD: return 0.0
	return value

func _process(_delta):
	var right = max(0.0, angular_accel)
	var left = max(0.0, -angular_accel)
	
	$rotaters/top_left.scale.y = right
	$rotaters/down_right.scale.y = right
	$rotaters/top_right.scale.y = left
	$rotaters/down_left.scale.y = left

func update_smoke():
	var speed = move_dir.length()
	
	$boosters/left.emitting = low_booster_active or speed > 0.1
	$boosters/right.emitting = low_booster_active or speed > 0.1
	$boosters/center.emitting = strong_booster_active or speed > 0.9

func _input(event):
	if event is InputEventJoypadMotion:
		if event.axis == JOY_AXIS_LEFT_X: move_dir.x = joy_axis_move(event.axis_value)
		elif event.axis == JOY_AXIS_LEFT_Y: move_dir.y = joy_axis_move(event.axis_value)
		
		if event.axis == JOY_AXIS_RIGHT_X: angular_accel = joy_axis_move(event.axis_value)
		
		if event.is_action_pressed("shoot_left"): arm[Arm_Left].shoot()
		if event.is_action_pressed("shoot_right"): arm[Arm_Right].shoot()
	else:
		if event.is_action_pressed("ui_left"): move_dir.x = -1
		elif event.is_action_pressed("ui_right"): move_dir.x = 1
		elif event.is_action_released("ui_left") or event.is_action_released("ui_right"): move_dir.x = 0

		if event.is_action_pressed("ui_up"): move_dir.y = -1
		elif event.is_action_pressed("ui_down"): move_dir.y = 1
		elif event.is_action_released("ui_up") or event.is_action_released("ui_down"): move_dir.y = 0
		
		if event.is_action_pressed("rotate_left"): angular_accel = -1
		if event.is_action_pressed("rotate_right"): angular_accel = 1
		elif event.is_action_released("rotate_left") or event.is_action_released("rotate_right"): angular_accel = 0
		
		if event.is_action_pressed("shoot_left"): arm[Arm_Left].shoot()
		if event.is_action_pressed("shoot_right"): arm[Arm_Right].shoot()
	
		if event.is_action_pressed("lights_left"): arm[Arm_Left].toggle_light()
		if event.is_action_pressed("lights_right"): arm[Arm_Right].toggle_light()
	
#	move_dir.x = clampf(move_dir.x, -1, 1)
#	move_dir.y = clampf(move_dir.y, -1, 1)
	update_smoke()

var dead = false
func kill():
	if dead:
		return
	
	dead = true
	set_physics_process(false)
	set_process_input(false)
	move_dir = Vector2()
	update_smoke()
	print("Player died")
	
	$explosion/AnimationPlayer.play("explode")
	await $explosion/AnimationPlayer.animation_finished
	player_died.emit()
