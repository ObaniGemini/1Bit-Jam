extends "res://scenes/main/level.gd"


# Detect right room is finished to unlock right generator
# Same for left room

# Pipeline :
# 1. R/L Room is destroyed
# 2. Unlocks generators (remove shield)
# 3. Generator 1 destroyed -> remove first reactor shield
# 4. Generator 2 destroyed -> remove second reactor shield
# 5. Reactor is exposed and can be destroyed

var EnemySmallShip = preload("res://scenes/enemies/reactor/EnemySmallShip.tscn")

var spawn_positions = []
var max_enemies = 0

func _ready():
	$Ship.set_camera_mode($Ship.Camera_Follow)
	
	var markers = $SpawnPositions.get_children()
	for i in range(len(markers)):
		spawn_positions.append(markers[i])
	
func end_of_level():
	pass

enum State {
	DESTROY_ROOMS,
	GENERATOR1,
	GENERATOR2,
	DESTROY_GENERATOR1,
	DESTROY_GENERATOR2,
	DESTROY_REACTOR
}

var state = State.DESTROY_ROOMS

func _process(_delta):
#	if state == State.GENERATOR2:
#		spawn_enemies()
#		state = State.DESTROY_GENERATOR1
	var nb = max_enemies - len($Enemies.get_children())
	if  nb > 0:
		spawn_enemies(nb)

func spawn_enemies(nb=-1):
	if nb == -1:
		spawn_on_all_markers()
	else:
		spawn_furthest(nb)

func spawn_furthest(nb):
	# Sort markers by distance to the player
	var ship = $Ship
	var sorted_positions = []
	for i in range(len(spawn_positions)):
		var marker = spawn_positions[i]
		var d = ship.position.distance_to(marker.position)
		sorted_positions.append([d, marker.global_position])
	
	sorted_positions.sort_custom(func(a, b): a[0] > b[0])

	# Spawn enemies on descending order
	for i in range(nb):
		var ess = EnemySmallShip.instantiate()
		ess.position = sorted_positions[i % len(sorted_positions)][1]
		$Enemies.add_child(ess)
	

func spawn_on_all_markers():
	for i in range(len(spawn_positions)):
		var ess = EnemySmallShip.instantiate()
		ess.global_position = spawn_positions[i].global_position
		$Enemies.add_child(ess)
		

func _on_right_room_destroyed():
	$Generators/Right.remove_shield()
	$Decor/LineRoomGeneratorRight.modulate = Color(0, 0, 0)
	$screenshake.play("screen_shake")
	if state == State.DESTROY_ROOMS:
		state = State.GENERATOR1
		max_enemies = 2
	else:
		state = State.GENERATOR2
		max_enemies = 4

func _on_left_room_destroyed():
	$Generators/Left.remove_shield()
	$Decor/LineRoomGeneratorLeft.modulate = Color(0, 0, 0)
	$screenshake.play("screen_shake")
	if state == State.DESTROY_ROOMS:
		state = State.GENERATOR1
		max_enemies = 2
	else:
		state = State.GENERATOR2
		max_enemies = 4
	
func _on_right_generator_destroyed():
	$Reactor.remove_outer_shield()
	$Decor/lightRight/AnimationPlayer.play("destroy")
	$screenshake.play("screen_shake")
	if state == State.DESTROY_GENERATOR1:
		state = State.DESTROY_GENERATOR1
		max_enemies = 6
	else:
		state = State.DESTROY_REACTOR
		max_enemies = 8

func _on_left_generator_destroyed():
	$Reactor.remove_inner_shield()
	$Decor/lightLeft/AnimationPlayer.play("destroy")
	$screenshake.play("screen_shake")
	if state == State.DESTROY_GENERATOR1:
		state = State.DESTROY_GENERATOR1
		max_enemies = 6
	else:
		state = State.DESTROY_REACTOR
		max_enemies = 8
	
func _on_reactor_destroyed():
	end_of_level()
