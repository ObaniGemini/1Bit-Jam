extends StaticBody2D

const MIN_SHOOTING_TIME = 2.0
const MAX_SHOOTING_TIME = 4.0

const BULLET_SPEED = 300

var EnemyBullet = preload("res://scenes/enemies/turrets/EnemyBullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$ShootingTimer.wait_time = randf_range(MIN_SHOOTING_TIME, MAX_SHOOTING_TIME)


func _physics_process(_delta):
	var ship = get_node("/root/World").level_scene.get_node("Ship")
	var angle = $TurretBase.global_position.angle_to_point(ship.global_position)
	if (rotation - angle) > PI or (rotation - angle) < -PI:
		angle = rotation
	rotation = angle

func damage(_hitpoint):
	destroy()

func destroy():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("bullet") or body.is_in_group("player"):
		destroy()

func shooting_direction():
	return ($TurretHead.global_position - $TurretBase.global_position).normalized()

func shoot_bullet():
	var bullet: PhysicsBody2D = EnemyBullet.instantiate()
	bullet.position = $TurretHead.global_position
	bullet.linear_velocity = shooting_direction() * BULLET_SPEED
	Entities.add_child(bullet)

func _on_shooting_timer_timeout():
	shoot_bullet()
