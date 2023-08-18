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
	if state == State.GENERATOR2:
		spawn_enemies()
		state = State.DESTROY_GENERATOR1


func spawn_enemies():
	for i in range(len(spawn_positions)):
		var ess = EnemySmallShip.instantiate()
		ess.global_position = spawn_positions[i].global_position
		add_child(ess)
		

func _on_right_room_destroyed():
	$Generators/Right.remove_shield()
	$Decor/LineRoomGeneratorRight.modulate = Color(0, 0, 0)
	if state == State.DESTROY_ROOMS:
		state = State.GENERATOR1
	else:
		state = State.GENERATOR2

func _on_left_room_destroyed():
	$Generators/Left.remove_shield()
	$Decor/LineRoomGeneratorLeft.modulate = Color(0, 0, 0)
	if state == State.DESTROY_ROOMS:
		state = State.GENERATOR1
	else:
		state = State.GENERATOR2
	
func _on_right_generator_destroyed():
	$Reactor.remove_outer_shield()
	$Decor/lightRight/AnimationPlayer.play("destroy")
	if state == State.DESTROY_GENERATOR1:
		state = State.DESTROY_GENERATOR1
	else:
		state = State.DESTROY_REACTOR

func _on_left_generator_destroyed():
	$Reactor.remove_inner_shield()
	$Decor/lightLeft/AnimationPlayer.play("destroy")
	if state == State.DESTROY_GENERATOR1:
		state = State.DESTROY_GENERATOR1
	else:
		state = State.DESTROY_REACTOR
	
func _on_reactor_destroyed():
	end_of_level()
