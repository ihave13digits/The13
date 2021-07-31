extends KinematicBody

var gravity = Vector3.DOWN * 12  # strength of gravity

var speed = 4  # movement speed

var jump_speed = 6  # jump strength

var spin = 0.1  # rotation speed


var velocity = Vector3.ZERO
var jump = false

func get_input():
	velocity.x = 0
	velocity.z = 0
	if Input.is_action_pressed("move_forward"):
		velocity.z += speed
	if Input.is_action_pressed("move_back"):
		velocity.z -= speed
	if Input.is_action_pressed("strafe_right"):
		velocity.x -= speed
	if Input.is_action_pressed("strafe_left"):
		velocity.x += speed

func _physics_process(delta):
	velocity += gravity * delta
	get_input()
	velocity = move_and_slide(velocity, Vector3.UP)
