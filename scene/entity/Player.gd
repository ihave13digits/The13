extends KinematicBody

signal pause_game
signal update_cursor
signal triggered_event

var trigger_worm = 17

var gravity = Vector3.DOWN * 0.5  # strength of gravity

var player_height = 1.8 # about 5'10"

var speed = 400 # movement speed
var run_speed = 900 # running speed
var jump_speed = 400000000  # jump strength
var spin = 0.1  # rotation speed
var pan_speed = 24.0

var max_pitch = 60.0 # maximum vertical angle
var _yaw = 0.0 # left/right
var _pitch = 0.0 # up/down

var velocity = Vector3.ZERO
var distance_tick = 0.0
var step_size = 0.75
var steps_taken = 0
var standing_on = 'dirt'

var jump = false
var aiming = false
var has_control = true
var can_walk = true
var can_look = true


var equipped_item = ''
var inventory = {
	'axe' : 0,
	'flashlight' : 0,
	}

onready var pivot = $Pivot
onready var cursor = $Pivot/Camera/Cursor
onready var flashlight_h = $Pivot/Camera/Flashlight
onready var flashlight_r = $Arms/Right/Flashlight
onready var flashlight_l = $Arms/Left/Flashlight
onready var bob_anim = $Bobbing
onready var camera = $Pivot/Camera



func _ready():
	update_quality()
	pivot.translation = Vector3(0, player_height-0.05, 0)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	if has_control:
		var can_do = false
		var vel = Vector3()
		var step_anim = "step"
		vel += gravity
		if vel.length() > 0.01:
			vel /= vel.length()

		if Input.is_action_just_pressed("menu"):
			if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				has_control = false
			elif Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				has_control = true
			emit_signal("pause_game")
		
		if Input.is_action_just_pressed("inventory"):
			var inv = load("res://scene/ui/Inventory.tscn").instance()
			get_parent().add_child(inv)
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			has_control = false

		if Input.is_action_just_pressed("use_item"):
			use_item()

		if Input.is_action_just_pressed("jump"):# && is_on_floor():
			vel += Vector3.UP*jump_speed

		if Input.is_action_pressed("aim_flashlight"):
			aiming = true
			set_flashlights()
		if Input.is_action_just_released("aim_flashlight"):
			aiming = false
			set_flashlights()

		if can_walk:
			if Input.is_action_pressed("move_forward"):
				vel += $Arms.get_transform().basis.z
				can_do = true
			elif Input.is_action_pressed("move_back"):
				vel -= $Arms.get_transform().basis.z
				can_do = true
			if Input.is_action_pressed("strafe_right"):
				vel -= $Arms.get_transform().basis.x
				can_do = true
			elif Input.is_action_pressed("strafe_left"):
				vel += $Arms.get_transform().basis.x
				can_do = true

		if can_look:
			if Input.is_action_pressed("pan_up"):
				_pitch -= pan_speed * spin
				update_rotations()
			elif Input.is_action_pressed("pan_down"):
				_pitch += pan_speed * spin
				update_rotations()
			if Input.is_action_pressed("pan_left"):
				_yaw += pan_speed * spin
				update_rotations()
			elif Input.is_action_pressed("pan_right"):
				_yaw -= pan_speed * spin
				update_rotations()

		var motion
		if Input.is_action_pressed("run"):
			step_anim = "step_fast"
			motion = vel.normalized() * (run_speed * delta)
		else:
			motion = vel.normalized() * (speed * delta)

		if can_do:
			update_distance(delta)
			$Bobbing.play(step_anim)
			if !aiming:
				$Swinging.play("step")

		motion = move_and_slide(motion, Vector3.UP, false, 4, 0.78, true)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if can_look:
			if cursor.get_collider() != null:
				var target = cursor.get_collider().get_parent()
				if target.has_method('hide_from_player') && target.visible == true:
					target.hide_from_player()
			emit_signal("update_cursor")
			_yaw -= event.relative.x * spin
			_pitch += event.relative.y * spin
			update_rotations()


func update_rotations():
	if _pitch > max_pitch:
		_pitch = max_pitch
	elif _pitch < -max_pitch:
		_pitch = -max_pitch
	pivot.set_rotation(Vector3(0, deg2rad(_yaw), 0))
	pivot.rotate(pivot.get_transform().basis.x.normalized(), deg2rad(_pitch))
	$Arms.set_rotation(Vector3(0, deg2rad(_yaw), 0))

func update_distance(delta):
	distance_tick += delta
	if distance_tick >= step_size:
		distance_tick -= step_size
		steps_taken += 1
	if steps_taken > trigger_worm:
		emit_signal("triggered_event")



func add_item(obj_id, amnt):
	if inventory.has(obj_id):
		inventory[obj_id] += amnt

func use_item():
	if cursor.get_collider() != null:
		if cursor.get_collider().has_method('get_message'):
			if cursor.get_collider().collectable:
				add_item(cursor.get_collider().object_id, cursor.get_collider().drop_amount)
				cursor.get_collider().queue_free()
			
			# Needs Refining
			if cursor.get_collider().object_id == 'axe' && is_instance_valid(get_parent().figure):
				get_parent().figure.visible = true
				get_parent().figure.hitbox.disabled = false
			get_parent().display_message(cursor.get_collider().get_message())
	if equipped_item == 'axe':
		$Equipped.play('axe')

func equip_item(obj_id):
	if inventory.has(obj_id):
		if inventory[obj_id] > 0:
			if obj_id == 'flashlight':
				flashlight_r.visible = true
			if obj_id == 'axe':
				$Arms/Right.visible = true
				$Arms/Right/Item.mesh = load(Data.equip['axe'])
				$Arms/Right/Item.set_material_override(load("res://material/object_material.tres"))
				swap_flashlight()
	equipped_item = obj_id



func set_flashlights():
	if aiming:
		flashlight_h.visible = true
	else:
		flashlight_h.visible = false
		flashlight_r.translation = Vector3(-0.5, -0.75, 0)
		flashlight_l.translation = Vector3(0.5, -0.75, 0)

func swap_flashlight():
	flashlight_r.visible = !flashlight_r.visible
	flashlight_l.visible = !flashlight_l.visible



func update_quality():
	camera.far = Data.settings['render_distance']*8190.0 + 2.0
	$Pivot/Camera/Flashlight.shadow_enabled = Data.shadows_enabled
	flashlight_r.shadow_enabled = Data.shadows_enabled
	flashlight_l.shadow_enabled = Data.shadows_enabled


func _on_Footsteps_finished():
	var index = randi() % 3
	$Footsteps.stream = Data.footstep[standing_on][index]
