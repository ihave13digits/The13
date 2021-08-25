extends Spatial

var roaches = []

func _ready():
	reset_roaches((randi() % 25) + 25)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		reset_roaches((randi() % 25) + 25)

func reset_roaches(val):
	for _i in range(roaches.size()):
		roaches[0].queue_free()
		roaches.pop_front()
	
	for _i in range(val):
		var roach = Data.mob['roach'].instance()
		var x = randf()
		var z = randf()
		var s = clamp(randf(), 0.5, 1.0) * 3.0
		var r = randi() % 360
		roach.translation = Vector3(x, 0.0, z)
		roach.scale = Vector3(s, s, s)
		roach.rotation_degrees = Vector3(0, r, 0)
		add_child(roach)
		roaches.append(roach)
