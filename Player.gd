extends RigidBody2D


var angle_speed = 120
var angle_change = 0
var vel_orig = Vector2(1, 0)
var vel = Vector2(1, 0)
var speed = 0
var reset = false
var start_pos = null
var start_angle = null
var shoot_timer = .5
export(String) var move_forward = 'player1_forward'
export(String) var move_back = 'player1_back'
export(String) var move_left = 'player1_left'
export(String) var move_right = 'player1_right'
export(String) var color = '57ff49'
# Player 1 color: '57ff49'
# Player 2 color: '2629df'

func _ready():
	set_process_input(true)
	set_physics_process(true)
	custom_integrator = true
	angular_damp = 10
	$Polygon2D.color = color
	$Particles2D.modulate = color


func _input(event):
	if event.is_action_pressed(move_forward):
		speed = 300
	elif event.is_action_pressed(move_back):
		speed = -300
	elif event.is_action_pressed(move_left):
		angle_change = -angle_speed
	elif event.is_action_pressed(move_right):
		angle_change = angle_speed
	
	elif event.is_action_released(move_forward):
		speed = 0
	elif event.is_action_released(move_back):
		speed = 0
	elif event.is_action_released(move_left):
		angle_change = 0
	elif event.is_action_released(move_right):
		angle_change = 0


func _physics_process(delta):
	shoot_timer -= delta
	
	if angle_change != 0:
		angular_velocity = angle_change * delta
	else:
		angular_velocity = 0
	
	accelerate(delta)


func accelerate(delta):
	if speed != 0:
		vel = vel_orig.rotated(rotation) * speed * delta
		apply_impulse(Vector2(), vel)


func _integrate_forces(state):
	if reset:
		state.transform = Transform2D(start_angle, start_pos)
		state.linear_velocity = Vector2()
		reset = false