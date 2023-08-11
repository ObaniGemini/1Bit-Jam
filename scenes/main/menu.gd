extends Node2D

const WORLD_PATH = "res://scenes/main/world.tscn"

func play():
	get_tree().change_scene_to_file(WORLD_PATH)


func quit():
	print("Bye")
	get_tree().quit()
