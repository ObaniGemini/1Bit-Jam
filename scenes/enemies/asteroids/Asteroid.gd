extends RigidBody2D

class_name Asteroids

# Generate a random asteroid with adapted sprite & collision shape

const ASTEROID_SPEED_MIN = 20
const ASTEROID_SPEED_MAX = 80

const ASTEROID_ANGULAR_MIN = 0.5
const ASTEROID_ANGULAR_MAX = 2

static var big_asteroids = [
	preload("res://scenes/enemies/asteroids/BigAsteroid1.tscn"),
	preload("res://scenes/enemies/asteroids/BigAsteroid2.tscn"),
	preload("res://scenes/enemies/asteroids/BigAsteroid3.tscn")
]

static var mini_asteroids = [
	preload("res://scenes/enemies/asteroids/MiniAsteroid1.tscn"),
	preload("res://scenes/enemies/asteroids/MiniAsteroid2.tscn"),
	preload("res://scenes/enemies/asteroids/MiniAsteroid3.tscn")
]

static func random_asteroid(big_asteroid_prob):
	var big_asteroid = randf() < big_asteroid_prob
	
	var arr = mini_asteroids
	if big_asteroid: arr = big_asteroids
	
	return arr.pick_random().instantiate()

func _ready():
	var speed = randf_range(ASTEROID_SPEED_MIN, ASTEROID_SPEED_MAX)
	var dir_angle = randf_range(1.0/6 * PI, 5.0 / 6 * PI)
	var direction = Vector2(cos(dir_angle), sin(dir_angle))
	linear_velocity = direction * speed
	angular_velocity = randf_range(ASTEROID_ANGULAR_MIN, ASTEROID_ANGULAR_MAX)
	
	add_to_group("enemy")
	add_to_group("asteroid")
	
	gravity_scale = 0
	linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	angular_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	set_collision_layer_value(2, true)
	set_collision_layer_value(1, false)

	set_collision_mask_value(2, true)
	set_collision_mask_value(1, false)
