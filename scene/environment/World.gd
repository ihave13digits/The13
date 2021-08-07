extends Spatial

var grass1 = null
var grass2 = null
var grass3 = null


func _ready():
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
	else:
		grass1 = Data.object['grass1'].instance()
		add_child(grass1)
		grass2 = Data.object['grass2'].instance()
		add_child(grass2)
		grass3 = Data.object['grass3'].instance()
		add_child(grass3)
	
