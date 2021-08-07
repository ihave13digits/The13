extends Node

# Configuration Settings
var bells_and_whistles = true

# Event Triggers
var trigger_worm = false

var env

var footstep = {
	'dirt' : [
		preload("res://audio/effect/dirt0.wav"),
		preload("res://audio/effect/dirt1.wav"),
		preload("res://audio/effect/dirt2.wav"),
		]
	}

var object = {
	'grass1' : preload("res://scene/environment/Grass1.tscn"),
	'grass2' : preload("res://scene/environment/Grass2.tscn"),
	'grass3' : preload("res://scene/environment/Grass3.tscn"),
	}

var mob = {
	'player' : preload("res://scene/entity/Player.tscn"),
	'figure' : preload("res://scene/entity/Figure.tscn"),
	'worm' : preload("res://scene/entity/Worm.tscn"),
	}



func _ready():
	env = WorldEnvironment.new()
	env.set_environment(load("res://default_env.tres"))
