extends Area2D

const DAMAGE_PER_SECOND = 75.0

@onready var speed = 200

var targets = []
var idx = 0
var tween = null

func destroy():
	queue_free()

func _ready():
	targets.append(position)
	
	for node in get_children():
		if node is Marker2D:
			targets.append(position + node.position * scale)
	
	stop_attack()
	
	if targets.size() > 1:
		next()

func next():
	idx = (idx + 1) % targets.size()
	tween = get_tree().create_tween()
	tween.tween_property(self, "position", targets[idx], position.distance_to(targets[idx]) / speed)
	tween.tween_callback(next)

var player = null
func _physics_process(delta):
	if player.health <= 0.0:
		stop_attack()
	else:
		player.damage(DAMAGE_PER_SECOND * delta)

func attack(body):
	player = body
	$idle.stop()
	$detected.play()
	$AnimationPlayer.speed_scale = 4.0
	set_physics_process(true)

func stop_attack():
	set_physics_process(false)
	$idle.play()
	$detected.stop()
	$AnimationPlayer.speed_scale = 1.0
	player = null

func _on_body_entered(body):
	if body.is_in_group("player"):
		attack(body)


func _on_body_exited(body):
	if body.is_in_group("player"):
		stop_attack()
