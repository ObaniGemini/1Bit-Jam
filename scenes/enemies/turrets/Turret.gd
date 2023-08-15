extends StaticBody2D

const MIN_SHOOTING_TIME = 2.0
const MAX_SHOOTING_TIME = 4.0

const BULLET_SPEED = 300
const BULLET_OFFSET = 20

var EnemyBullet = preload("res://scenes/enemies/turrets/EnemyBullet.tscn")

# Called when the node enters the scene tree for the first time.
@onready var BASE_ANGLE = rotation
@onready var MIN_ANGLE = BASE_ANGLE - PI/3
@onready var MAX_ANGLE = BASE_ANGLE + PI/3
var ship = null

var shooting = false

func _ready():
	if get_tree().current_scene.name == "World":
		ship = get_tree().current_scene.level_scene.get_node("Ship")
	else: ### That's for testing
		ship = get_tree().current_scene.get_node("Ship")
	$ShootingTimer.wait_time = randf_range(MIN_SHOOTING_TIME, MAX_SHOOTING_TIME)


func _physics_process(_delta):
	var angle = global_position.angle_to_point(ship.global_position) + PI/2 - get_parent().global_rotation
	shooting = angle > MIN_ANGLE and angle < MAX_ANGLE
	
	if shooting:
		rotation = clampf(angle, MIN_ANGLE, MAX_ANGLE)

func damage(_hitpoint):
	destroy()

func destroy():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("bullet") or body.is_in_group("player"):
		destroy()

func shoot_bullet():
	if !shooting:
		return
	
	var bullet: PhysicsBody2D = EnemyBullet.instantiate()
	var bullet_angle = global_rotation - PI/2
	var direction = Vector2(cos(bullet_angle), sin(bullet_angle))
	bullet.position = global_position + direction * BULLET_OFFSET
	bullet.linear_velocity = direction * BULLET_SPEED
	bullet.rotation = bullet_angle
	Entities.add_child(bullet)

func _on_shooting_timer_timeout():
	shoot_bullet()
