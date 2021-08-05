extends Node

var trigger_worm = false

var env

var footstep = {
	'dirt' : [
		preload("res://audio/effect/dirt0.wav"),
		preload("res://audio/effect/dirt1.wav"),
		preload("res://audio/effect/dirt2.wav"),
		]
	}

var mob = {
	'player' : preload("res://scene/entity/Player.tscn"),
	'worm' : preload("res://scene/entity/Worm.tscn"),
	}

func _ready():
	env = WorldEnvironment.new()
	env.set_environment(load("res://default_env.tres"))
