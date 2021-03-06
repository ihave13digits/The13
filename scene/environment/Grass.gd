extends Spatial

var size = 250



func _ready():
	$Meshes.multimesh.instance_count = Data.settings['detail_level']*5000.0
	
	for i in range($Meshes.multimesh.instance_count):
		var X = (randi() % size) - float(size)/2.0 + randf()
		var Z = (randi() % size) - float(size)/2.0 + randf()
		var position = Transform(Basis(), Vector3(X, 125, Z))
		$Meshes.multimesh.set_instance_transform(i, position)
