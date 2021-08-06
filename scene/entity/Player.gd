extends KinematicBody

signal pause_game
signal update_cursor
signal triggered_event

var gravity = Vector3.DOWN * 1.0  # strength of gravity

var player_height = 1.8 # about 5'10"

var speed = 400 # movement speed
var run_speed = 600 # running speed
var jump_speed = 400  # jump strength
var spin = 0.1  # rotation speed
var pan_speed = 24.0

var max_pitch = 60.0 # maximum vertical angle
var _yaw = 0.0 # left/right
var _pitch = 0.0 # up/down

var velocity = Vector3.ZERO
var distance_tick = 0.0
var step_size = 0.75
var steps_taken = 0

var jump = false
var aiming = false
var has_control = true

onready var pivot
onready var cursor
onready var flashlight
onready var bob_anim
onready var camera



func _ready():
	pivot = $Pivot
	cursor = $Pivot/Camera/Cursor
	flashlight = $Pivot/Flashlight
	bob_anim = $Bobbing
	
	pivot.translation = Vector3(0, player_height-0.05, 0)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	camera = $Pivot/Camera

func _physics_process(delta):
	if has_control:
		var can_do = false
		var vel = Vector3()
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
		
		if Input.is_action_just_pressed("use_item"):
			use_item()
		
		if Input.is_action_just_pressed("jump"):# && is_on_floor():
			vel -= gravity*jump_speed
		
		if Input.is_action_pressed("aim_flashlight"):
			aiming = true
			flashlight.translation = Vector3(-0.125, -0.05, 0)
			flashlight.rotation_degrees = Vector3(0, 180, 0)
		if Input.is_action_just_released("aim_flashlight"):
			aiming = false
			flashlight.translation = Vector3(-0.5, -0.75, 0)
		
		if Input.is_action_pressed("move_forward"):
			vel += pivot.get_transform().basis.z
			can_do = true
		elif Input.is_action_pressed("move_back"):
			vel -= pivot.get_transform().basis.z
			can_do = true
		if Input.is_action_pressed("strafe_right"):
			vel -= pivot.get_transform().basis.x
			can_do = true
		elif Input.is_action_pressed("strafe_left"):
			vel += pivot.get_transform().basis.x
			can_do = true
		
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
		
		if can_do:
			update_distance(delta)
			$Bobbing.play("step")
			if !aiming:
				$Swinging.play("step")

		var motion = vel.normalized() * (speed * delta)
		motion = move_and_slide(motion, Vector3.UP, false, 4, 0.78, true)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
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

func update_distance(delta):
	distance_tick += delta
	if distance_tick >= step_size:
		distance_tick -= step_size
		steps_taken += 1
	if steps_taken > 17:
		emit_signal("triggered_event")

func use_item():
	if cursor.get_collider() != null:
		if cursor.get_collider().has_method('get_message'):
			get_parent().display_message(cursor.get_collider().get_message())
			get_parent().figure.visible = true

func _on_Footsteps_finished():
	var index = randi() % 3
	$Footsteps.stream = Data.footstep['dirt'][index]
