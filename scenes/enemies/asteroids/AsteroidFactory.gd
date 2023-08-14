extends Node

class_name AsteroidFactory

static var big_asteroids = [
	load("res://scenes/enemies/asteroids/BigAsteroid1.tscn"),
	load("res://scenes/enemies/asteroids/BigAsteroid2.tscn"),
	load("res://scenes/enemies/asteroids/BigAsteroid3.tscn")
]

static var mini_asteroids = [
	load("res://scenes/enemies/asteroids/MiniAsteroid1.tscn"),
	load("res://scenes/enemies/asteroids/MiniAsteroid2.tscn"),
	load("res://scenes/enemies/asteroids/MiniAsteroid3.tscn")
]

static var mega_asteroids = [
	load("res://scenes/enemies/asteroids/MegaAsteroid1.tscn"),
	load("res://scenes/enemies/asteroids/MegaAsteroid2.tscn"),
]


static func random_asteroid(big_asteroid_prob):
	var big_asteroid = randf() < big_asteroid_prob
	
	var arr = mini_asteroids
	if big_asteroid: arr = big_asteroids
	
	return arr.pick_random().instantiate()


static 	func spawn_mega(number):
	var arr = []
	for i in  range(number):
		arr.append(mega_asteroids.pick_random().instantiate())
	return arr
