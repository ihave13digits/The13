extends Node

onready var hud = $HUD
onready var cursor = $HUD/Center/Cursor
onready var player
onready var world = $World

onready var figure = $Figure



func _ready():
	player = Data.mob['player'].instance()
	add_child(player)
	player.connect('update_cursor', self, 'update_cursor')
	player.connect('triggered_event', self, 'spawn')
	player.connect('pause_game', self, 'toggle_pause')
	hud.connect('end_game', self, 'end_game')

func display_message(message):
	var msg = load("res://scene/ui/PopupMessage.tscn").instance()
	msg.message = message
	add_child(msg)

func update_cursor():
	if player.cursor.get_collider() != null:
		cursor.modulate = Color(1.0, 1.0, 1.0, 0.5)
	else:
		cursor.modulate = Color(1.0, 1.0, 1.0, 0.125)

func toggle_pause():
	var menu = load("res://scene/ui/PauseMenu.tscn").instance()
	add_child(menu)

func spawn(m='worm'):
	match m:
		'worm' :
			if Data.trigger_worm == false:
				Data.trigger_worm = true
				var i = Data.mob[m].instance()
				i.translation = player.translation
				add_child(i)
				hud.anim.play("fade")
		'figure' :
			var i = Data.mob[m].instance()
			i.translation = Vector3()
			add_child(i)

func end_game():
	var _can_do = get_tree().change_scene("res://scene/ui/Credits.tscn")
