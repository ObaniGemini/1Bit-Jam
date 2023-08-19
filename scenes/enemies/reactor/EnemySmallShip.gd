extends RigidBody2D

const EnemyBullet = preload("res://scenes/enemies/turrets/EnemyBullet.tscn")
const EXPLOSION_CLASS = preload("res://scenes/util/explosion.tscn")

const SPEED = 100000.0
const BULLET_SPEED = 400.0
var health = 1

const MIN_DISTANCE = 800

var shooting = false
var ship = null

const MIN_SHOOTING_SPEED = 4.0
const MAX_SHOOTING_SPEED = 10.0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemy")
	rotation = PI / 2
	if get_tree().current_scene.name == "World":
		ship = get_tree().current_scene.level_scene.get_node("Ship")
	else: ### That's for testing
		ship = get_tree().current_scene.get_node("Ship")
	
	$ShootingTimer.wait_time = randf_range(MIN_SHOOTING_SPEED, MAX_SHOOTING_SPEED)
	$ShootingTimer.timeout.connect(shoot_bullet)
	$ShootingTimer.start()

func damage(dmg):
	health -= dmg
	if health <= 0:
		destroy()

func destroy():
	var explosion = EXPLOSION_CLASS.instantiate()
	explosion.set_force(32 + randi() % 32)
	explosion.position = global_position
	Entities.add_child(explosion)
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	shooting = position.distance_to(ship.position) < MIN_DISTANCE
	apply_force(position.direction_to(ship.position) * SPEED * delta)
	rotation = position.angle_to_point(ship.position)

func shoot_bullet():
	if !shooting:
		return
	
	var vel = BULLET_SPEED * Vector2(cos(rotation), sin(rotation))
	for cannon in [$LeftShooter, $RightShooter]:
		var bullet = EnemyBullet.instantiate()
		bullet.add_collision_exception_with(self)
		bullet.position = cannon.global_position
		bullet.linear_velocity = vel
		bullet.rotation = rotation
		Entities.add_child(bullet)
	
	$ShootingTimer.wait_time = randf_range(MIN_SHOOTING_SPEED, MAX_SHOOTING_SPEED)
