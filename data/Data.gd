extends Node

# Configuration Settings
var env

var bells_and_whistles = true
var shadows_enabled = true
var data_file = "user://game_state.json"

var sky_color = {
	'early_night' : {
		'sky' : Color(0.15, 0.00, 0.25),
		'fog' : Color(0.40, 0.40, 0.40),
		'base' : Color(0.20, 0.00, 0.30),
		},
	'night' : {
		'sky' : Color(0.10, 0.00, 0.20),
		'fog' : Color(0.35, 0.35, 0.35),
		'base' : Color(0.15, 0.00, 0.25),
		},
	'late_night' : {
		'sky' : Color(0.00, 0.00, 0.80),
		'fog' : Color(0.00, 0.00, 0.00),
		'base' : Color(1.00, 1.00, 1.00),
		},
	'early_morning' : {
		'sky' : Color(0.20, 0.20, 1.00),
		'fog' : Color(0.00, 0.00, 0.00),
		'base' : Color(1.00, 1.00, 1.00),
		},
	'morning' : {
		'sky' : Color(0.40, 0.40, 1.00),
		'fog' : Color(0.00, 0.00, 0.00),
		'base' : Color(1.00, 1.00, 1.00),
		},
	'late_morning' : {
		'sky' : Color(0.60, 0.60, 1.00),
		'fog' : Color(0.00, 0.00, 0.00),
		'base' : Color(1.00, 1.00, 1.00),
		},
	'noon' : {
		'sky' : Color(0.80, 0.80, 1.00),
		'fog' : Color(0.00, 0.00, 0.00),
		'base' : Color(1.00, 1.00, 1.00),
		},
	'early_afternoon' : {
		'sky' : Color(0.60, 0.60, 1.00),
		'fog' : Color(0.00, 0.00, 0.00),
		'base' : Color(1.00, 1.00, 1.00),
		},
	'afternoon' : {
		'sky' : Color(0.50, 0.40, 1.00),
		'fog' : Color(0.00, 0.00, 0.00),
		'base' : Color(1.00, 1.00, 1.00),
		},
	'late_afternoon' : {
		'sky' : Color(0.40, 0.20, 1.00),
		'fog' : Color(0.00, 0.00, 0.00),
		'base' : Color(1.00, 1.00, 1.00),
		},
	'early_evening' : {
		'sky' : Color(0.20, 0.00, 0.80),
		'fog' : Color(0.00, 0.00, 0.00),
		'base' : Color(1.00, 1.00, 1.00),
		},
	'evening' : {
		'sky' : Color(0.10, 0.00, 0.60),
		'fog' : Color(0.00, 0.00, 0.00),
		'base' : Color(1.00, 1.00, 1.00),
		},
	'late_evening' : {
		'sky' : Color(0.05, 0.00, 0.40),
		'fog' : Color(0.00, 0.00, 0.00),
		'base' : Color(1.00, 1.00, 1.00),
		},
}

var settings = {
	'render_distance' : 1.0,
	'detail_level' : 1.0,
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
	configure_settings()
	update_time('night')

func configure_settings():
	var threads = OS.get_processor_count()
	env.environment.dof_blur_far_enabled = bool(threads > 4)
	bells_and_whistles = bool(threads > 8)
	shadows_enabled = bool(threads > 4)

func update_time(time):
	var sky = env.environment.background_sky
	sky.sky_top_color = sky_color[time]['sky']
	sky.sky_horizon_color = sky_color[time]['base']
	sky.ground_bottom_color = sky_color[time]['base']
	sky.ground_horizon_color = sky_color[time]['base']
	env.environment.fog_color = sky_color[time]['fog']

func save_scores():
	var data = {'trigger' : trigger}
	var f = File.new()
	f.open(data_file, File.WRITE)
	f.store_line(to_json(data))

func load_scores():
	var data = {}
	var file = File.new()
	if !file.file_exists(data_file):
		return
	file.open(data_file, File.READ)
	data = parse_json(file.get_line())
	trigger = data['trigger']
