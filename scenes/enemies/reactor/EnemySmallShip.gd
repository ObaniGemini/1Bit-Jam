extends RigidBody2D

const EnemyBullet = preload("res://scenes/enemies/turrets/EnemyBullet.tscn")

const SPEED = 150.0
const BULLET_SPEED = 500.0
var life = 4

var rotation_speed = 4

const MAX_DISTANCE = 450.0
@onready var MIN_ANGLE = -PI/4
@onready var MAX_ANGLE = PI/4

var shooting = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rotation = PI / 2

func damage(hp):
	life -= hp
	if life <= 0:
		destroy()

func destroy():
	queue_free()

func get_player_position():
	var ship = null
	if get_tree().current_scene.name == "World":
		ship = get_tree().current_scene.level_scene.get_node("Ship")
	else: ### That's for testing
		ship = get_tree().current_scene.get_node("Ship")
	return ship.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var player_position = get_player_position()
	var direction = global_position.direction_to(player_position)
	linear_velocity = direction * SPEED
	
	var angle = global_position.angle_to_point(player_position) - global_rotation + PI / 2
	shooting = angle > MIN_ANGLE
	shooting = shooting and angle < MAX_ANGLE 
	shooting = shooting and global_position.distance_to(player_position) < MAX_DISTANCE
	rotation += angle * rotation_speed * delta

func shoot_bullet():
	if !shooting:
		return
	
	var l_bullet: PhysicsBody2D = EnemyBullet.instantiate()
	var l_bullet_angle = global_rotation - PI/2
	var l_direction = Vector2(cos(l_bullet_angle), sin(l_bullet_angle))
	l_bullet.position = $LeftShooter.position
	l_bullet.linear_velocity = l_direction * BULLET_SPEED
	l_bullet.rotation = l_bullet_angle
	Entities.add_child(l_bullet)
	
	var r_bullet: PhysicsBody2D = EnemyBullet.instantiate()
	var r_bullet_angle = global_rotation - PI/2
	var r_direction = Vector2(cos(r_bullet_angle), sin(r_bullet_angle))
	r_bullet.position = $LeftShooter.position
	r_bullet.linear_velocity = r_direction * BULLET_SPEED
	r_bullet.rotation = r_bullet_angle
	Entities.add_child(r_bullet)

func _on_shooting_timer_timeout():
	shoot_bullet()
