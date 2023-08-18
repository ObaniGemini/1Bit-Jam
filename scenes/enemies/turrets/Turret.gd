extends CharacterBody2D

const MIN_SHOOTING_TIME = 3.0
const MAX_SHOOTING_TIME = 6.0
const MAX_DISTANCE = 500.0

const BULLET_SPEED = 300
const BULLET_OFFSET = 20

const EnemyBullet = preload("res://scenes/enemies/turrets/EnemyBullet.tscn")
const EXPLOSION_CLASS = preload("res://scenes/util/explosion.tscn")

# Called when the node enters the scene tree for the first time.
@onready var MIN_ANGLE = -PI/3
@onready var MAX_ANGLE = PI/3
@onready var holder = $Sprites/holder
var ship = null

var shooting = false

func _ready():
	if get_tree().current_scene.name == "World":
		ship = get_tree().current_scene.level_scene.get_node("Ship")
	else: ### That's for testing
		ship = get_tree().current_scene.get_node("Ship")
	$ShootingTimer.wait_time = randf_range(MIN_SHOOTING_TIME, MAX_SHOOTING_TIME)

func _physics_process(_delta):
	var angle = global_position.angle_to_point(ship.global_position) - global_rotation
	shooting = angle > MIN_ANGLE and angle < MAX_ANGLE and global_position.distance_to(ship.global_position) < MAX_DISTANCE
	
	if shooting:
		holder.rotation = angle

func destroy():
	var explosion = EXPLOSION_CLASS.instantiate()
	explosion.set_force(16 + randi() % 16)
	explosion.position = global_position
	Entities.add_child(explosion)
	queue_free()

func shoot_bullet():
	if !shooting:
		return
	
	var bullet: PhysicsBody2D = EnemyBullet.instantiate()
	var bullet_angle = holder.global_rotation - PI/2
	var direction = Vector2(cos(bullet_angle), sin(bullet_angle))
	bullet.position = global_position + direction * BULLET_OFFSET
	bullet.linear_velocity = direction * BULLET_SPEED
	bullet.rotation = bullet_angle
	Entities.add_child(bullet)
	$Sprites/shoot.play("shoot")

func _on_shooting_timer_timeout():
	shoot_bullet()
