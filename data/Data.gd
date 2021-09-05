extends Node

# Configuration Settings
var env

var bells_and_whistles = true
var shadows_enabled = true

var settings = {
	'render_distance' : 400,
	'detail_level' : 1000,
	}

# Event Triggers
var trigger = {
	'worm' : false,
	}

var icon = {
	'axe' : preload("res://image/item/axe.png"),
	'flashlight' : preload("res://image/item/flashlight.png"),
	}

var footstep = {
	'dirt' : [
		preload("res://audio/effect/dirt0.wav"),
		preload("res://audio/effect/dirt1.wav"),
		preload("res://audio/effect/dirt2.wav"),
		]
	}

var equip = {
	'axe' : "res://mesh/item/axe.obj",
	}

var object = {
	'grass1' : preload("res://scene/environment/Grass1.tscn"),
	'grass2' : preload("res://scene/environment/Grass2.tscn"),
	'grass3' : preload("res://scene/environment/Grass3.tscn"),
	'fog' : preload("res://scene/environment/Fog.tscn"),
	}

var mob = {
	'player' : preload("res://scene/entity/Player.tscn"),
	'figure' : preload("res://scene/entity/Figure.tscn"),
	'worm' : preload("res://scene/entity/Worm.tscn"),
	'roach' : preload("res://scene/entity/Roach.tscn"),
	}



func _ready():
	env = WorldEnvironment.new()
	env.set_environment(load("res://default_env.tres"))
	
	var threads = OS.get_processor_count()
	
	env.environment.dof_blur_far_enabled = bool(threads > 4)
	bells_and_whistles = bool(threads > 8)
	shadows_enabled = bool(threads > 4)
