extends Spatial

var grass1 = null
var grass2 = null
var grass3 = null
var fog_patches = []


func _ready():
	Data.env.environment.fog_depth_end = 24
	Data.env.environment.fog_transmit_curve = 0.15
	$HorizonAnim.playback_speed = 0.01
	if Data.bells_and_whistles:
		for x in range(-5, 5):
			for z in range(-5, 5):
				var fog = Data.object['fog'].instance()
				fog.translation = Vector3(x*20, 15, z*20)
				add_child(fog)
	update_quality()

func update_quality():
	if Data.bells_and_whistles == false:
		if is_instance_valid(grass1):
			remove_child(grass1)
			grass1 = null
		if is_instance_valid(grass2):
			remove_child(grass2)
			grass2 = null
		if is_instance_valid(grass3):
			remove_child(grass3)
			grass3 = null
		for i in range(fog_patches.size()):
			fog_patches[i].queue_free()
		fog_patches.clear()
	else:
		grass1 = Data.object['grass1'].instance()
		add_child(grass1)
		grass2 = Data.object['grass2'].instance()
		add_child(grass2)
		grass3 = Data.object['grass3'].instance()
		add_child(grass3)
		for x in range(-5, 5):
			for z in range(-5, 5):
				var fog = Data.object['fog'].instance()
				add_child(fog)
				fog.translation = Vector3(x*20, 15, z*20)
				fog.particles.amount = clamp(Data.settings['detail_level']/100, 1, 15)
				fog_patches.append(fog)
	
