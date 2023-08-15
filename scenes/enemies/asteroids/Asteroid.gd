extends RigidBody2D

class_name Asteroids

# Generate a random asteroid with adapted sprite & collision shape

const ASTEROID_SPEED_MIN = 20
const ASTEROID_SPEED_MAX = 80

const ASTEROID_ANGULAR_MIN = 0.25
const ASTEROID_ANGULAR_MAX = 1.0

const ASTEROID_MEGA_ANGULAR_MIN = 0.001
const ASTEROID_MEGA_ANGULAR_MAX = 0.01

var Turret = preload("res://scenes/enemies/turrets/Turret.tscn")
const TURRET_PROBA = 0.5

enum AsteroidType {
	MINI,
	BIG,
	MEGA
}
@export var asteroid_type: AsteroidType = AsteroidType.MINI

var prop = {
	AsteroidType.MINI: {"mass": 1, "health_min": 1, "health_max": 1, "damage": 1},
	AsteroidType.BIG: {"mass": 1000, "health_min": 1, "health_max": 6, "damage": 20},
	AsteroidType.MEGA: {"mass": 10000, "health_min": 10000, "health_max": 10000, "damage": 30}
}

var health = 0

func init():
	var speed = randf_range(ASTEROID_SPEED_MIN, ASTEROID_SPEED_MAX)
	var direction = Vector2((randf() - 0.5) * 0.25, 1.0)

	var sign = signf(randf() - 0.5)
	if asteroid_type == AsteroidType.MEGA:
		linear_velocity = Vector2.DOWN * ASTEROID_SPEED_MIN
		angular_velocity = sign * randf_range(ASTEROID_MEGA_ANGULAR_MIN, ASTEROID_MEGA_ANGULAR_MAX)
	else:
		linear_velocity = direction * speed
		angular_velocity = sign * randf_range(ASTEROID_ANGULAR_MIN, ASTEROID_ANGULAR_MAX)

	add_to_group("enemy")
	add_to_group("asteroid")

	rotation = randf() * TAU
	gravity_scale = 0
	linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	angular_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	set_collision_layer_value(2, true)
	set_collision_layer_value(1, false)

	set_collision_mask_value(2, true)
	set_collision_mask_value(1, false)
	
	# Mass to have nice collision
	mass = prop[asteroid_type]["mass"]
	health = randi_range(prop[asteroid_type]["health_min"], prop[asteroid_type]["health_max"])
	if asteroid_type == AsteroidType.MINI:
		add_to_group("destroyable")

func _ready():
	init()

func destroy():
	queue_free()

func damage(i):
	health -= i
	if health <= 0:
		destroy()

func get_damages():
	return prop[asteroid_type]["damage"]
