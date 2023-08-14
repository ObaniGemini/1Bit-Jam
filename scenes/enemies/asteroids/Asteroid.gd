extends RigidBody2D

class_name Asteroids

# Generate a random asteroid with adapted sprite & collision shape

const ASTEROID_SPEED_MIN = 20
const ASTEROID_SPEED_MAX = 80

const ASTEROID_ANGULAR_MIN = 0.5
const ASTEROID_ANGULAR_MAX = 2

var Turret = preload("res://scenes/enemies/turrets/Turret.tscn")
const TURRET_PROBA = 0.5

@export var mega = false


func _ready():
	var speed = randf_range(ASTEROID_SPEED_MIN, ASTEROID_SPEED_MAX)
	var dir_angle = randf_range(1.0/6 * PI, 5.0 / 6 * PI)
	var direction = Vector2(cos(dir_angle), sin(dir_angle))

	if mega:
		linear_velocity = Vector2.DOWN * ASTEROID_SPEED_MIN
		angular_velocity = 0.01
	else:
		linear_velocity = direction * speed
		angular_velocity = randf_range(ASTEROID_ANGULAR_MIN, ASTEROID_ANGULAR_MAX)

	add_to_group("enemy")
	add_to_group("asteroid")

	gravity_scale = 0
	linear_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	angular_damp_mode = RigidBody2D.DAMP_MODE_REPLACE
	if mega:
		set_collision_layer_value(5, true)
		set_collision_layer_value(1, false)

		set_collision_mask_value(5, true)
		set_collision_mask_value(1, false)
	else:
		set_collision_layer_value(2, true)
		set_collision_layer_value(1, false)

		set_collision_mask_value(2, true)
		set_collision_mask_value(1, false)

func destroy():
	queue_free()
