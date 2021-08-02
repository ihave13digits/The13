extends KinematicBody

signal triggered_event

var gravity = Vector3.DOWN * 1.0  # strength of gravity

var player_height = 1.8 # about 5'10"

var speed = 400 # movement speed
var jump_speed = 6  # jump strength
var spin = 0.1  # rotation speed

var max_pitch = 60.0 # maximum vertical angle
var _yaw = 0.0 # left/right
var _pitch = 0.0 # up/down

var velocity = Vector3.ZERO
var distance_tick = 0.0
var bob_tick = 0.0
var steps_taken = 0

var jump = false
var has_control = true

onready var pivot
onready var flashlight



func _ready():
	pivot = $Pivot
	flashlight = $Pivot/Flashlight
	
	pivot.translation = Vector3(0, player_height-0.05, 0)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func get_input(delta):
	var can_do = false
	velocity.x = 0
	velocity.z = 0
	
	if Input.is_action_just_pressed("menu"):
		if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			has_control = false
		elif Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			has_control = true
	
	if Input.is_action_just_pressed("use_item"):
		print(distance_tick)
	
	if Input.is_action_pressed("move_forward"):
		velocity += pivot.get_transform().basis.z
		can_do = true
	elif Input.is_action_pressed("move_back"):
		velocity -= pivot.get_transform().basis.z
		can_do = true
	if Input.is_action_pressed("strafe_right"):
		velocity -= pivot.get_transform().basis.x
		can_do = true
	elif Input.is_action_pressed("strafe_left"):
		velocity += pivot.get_transform().basis.x
		can_do = true
	
	if can_do:
		update_distance(delta)

func update_distance(delta):
	pivot.translation = Vector3(0, player_height-0.05+(bob_tick*0.2), 0)
	#flashlight.rotation_degrees = Vector3(-bob_tick*15, -175+(bob_tick*15), 180-(bob_tick*15))
	distance_tick += delta*2
	bob_tick = distance_tick-0.5
	if distance_tick >= 1.0:
		distance_tick -= 1.0
		steps_taken += 1
		$Footsteps.playing = true
#		var tween = find_node('Tween')
#		tween.interpolate_property(
#			pivot,
#			'translation',
#			translation,
#			Vector3(0, player_height-0.05+(bob_tick*0.2), 0),
#			1.0,
#			Tween.TRANS_LINEAR
#			)
#		tween.start()
	if steps_taken > 100:
		emit_signal("triggered_event")

func _physics_process(delta):
	velocity += gravity
	get_input(delta)
	if velocity.length() > 0.01:
		velocity /= velocity.length()

	var motion = velocity * (speed * delta)
	motion = move_and_slide(motion, Vector3.UP, false, 4, 0.78, true)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_yaw -= event.relative.x * spin
		_pitch += event.relative.y * spin
		if _pitch > max_pitch:
			_pitch = max_pitch
		elif _pitch < -max_pitch:
			_pitch = -max_pitch
		pivot.set_rotation(Vector3(0, deg2rad(_yaw), 0))
		pivot.rotate(pivot.get_transform().basis.x.normalized(), deg2rad(_pitch))
