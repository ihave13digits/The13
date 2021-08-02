extends Node

var player

func _ready():
	player = load(Data.mob['player']).instance()
	add_child(player)
	player.connect('triggered_event', self, 'spawn')

func spawn(m='worm'):
	if Data.trigger_worm == false:
		Data.trigger_worm = true
		var i = load(Data.mob[m]).instance()
		i.translation = Vector3(player.translation.x, player.translation.y, player.translation.z)
		add_child(i)
