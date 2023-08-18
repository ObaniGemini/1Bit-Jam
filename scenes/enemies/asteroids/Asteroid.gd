extends RigidBody2D

class_name Asteroids

const EXPLOSION_CLASS = preload("res://scenes/util/explosion.tscn")

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
	AsteroidType.MINI: {"mass": 1, "health_min": 1, "health_max": 2, "damage": 0.01, "scale_min": 0.25},
	AsteroidType.BIG: {"mass": 1000, "health_min": 2, "health_max": 8, "damage": 0.04, "scale_min": 0.75},
	AsteroidType.MEGA: {"mass": 10000, "health_min": 60, "health_max": 100, "damage": 0.1, "scale_min": 1.0}
}

var health = 0
var speed_scale = 1.0

func init():
	var speed = randf_range(ASTEROID_SPEED_MIN, ASTEROID_SPEED_MAX) * speed_scale
	var direction = Vector2((randf() - 0.5) * 0.25, 1.0)

	var s = signf(randf() - 0.5)
	if asteroid_type == AsteroidType.MEGA:
		linear_velocity = Vector2.DOWN * ASTEROID_SPEED_MIN
		angular_velocity = s * randf_range(ASTEROID_MEGA_ANGULAR_MIN, ASTEROID_MEGA_ANGULAR_MAX)
	else:
		linear_velocity = direction * speed
		angular_velocity = s * randf_range(ASTEROID_ANGULAR_MIN, ASTEROID_ANGULAR_MAX)

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
	var props = prop[asteroid_type]
	mass = props["mass"]
	health = randi_range(props["health_min"], props["health_max"])
	scale *= randf_range(props["scale_min"], 1.0)
	if asteroid_type == AsteroidType.MINI:
		add_to_group("destroyable")
	
	contact_monitor = true
	max_contacts_reported = 1
	
	var bg = get_node("bg")
	if bg != null:
		bg.z_index = -5
	
	body_entered.connect(hit)

func _ready():
	init()

func destroy():
	if asteroid_type != AsteroidType.MINI:
		var explosion = EXPLOSION_CLASS.instantiate()
		if asteroid_type == AsteroidType.BIG: explosion.set_force(16 + randi() % 32)
		else: explosion.set_force(64 + randi() % 64)
		explosion.position = global_position
		Entities.add_child(explosion)
	queue_free()

func hit(body):
	if body.is_in_group("player"):
		body.damage(linear_velocity.distance_to(body.previous_velocity) * prop[asteroid_type]["damage"])

func damage(i):
	health -= i
	if health <= 0:
		destroy()
