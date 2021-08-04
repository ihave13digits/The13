extends Node

onready var hud
onready var cursor
onready var player

func _ready():
	hud = $HUD
	cursor = $HUD/Center/Cursor
	player = Data.mob['player'].instance()
	add_child(player)
	player.connect('update_cursor', self, 'update_cursor')
	player.connect('triggered_event', self, 'spawn')

func update_cursor():
	if player.cursor.get_collider() != null:
		cursor.modulate = Color(1.0, 1.0, 1.0, 0.5)
	else:
		cursor.modulate = Color(1.0, 1.0, 1.0, 0.125)

func spawn(m='worm'):
	match m:
		'worm':
			if Data.trigger_worm == false:
				Data.trigger_worm = true
				var i = Data.mob[m].instance()
				i.translation = Vector3(player.translation.x, player.translation.y, player.translation.z)
				add_child(i)
