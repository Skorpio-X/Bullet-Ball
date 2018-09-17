extends RigidBody2D


var angle_speed = 3 #120
var angle_change = 0
var angle_acc = 0
var vel_orig = Vector2(1, 0)
var vel = Vector2(1, 0)
var speed = 0
var max_speed = 10  # 300
var reset = false
var start_pos = null
var start_angle = null
var shoot_timer = global.fire_rate
var shoot_time = global.fire_rate  # Reset the timer to this value. Was 0.5, then 2.5.
export(String) var move_forward = 'player1_forward'
export(String) var move_back = 'player1_back'
export(String) var move_left = 'player1_left'
export(String) var move_right = 'player1_right'
# Player 1 color: '57ff49', color_ready: 'ccffcc', color_reloading: '18532e'
# Player 2 color: '2629df', color_ready: '00a5ff', color_reloading: '002662'
export(String) var color = '57ff49'
export(String) var color_ready = 'ccffcc'
export(String) var color_reloading = '18532e'


func _ready():
	set_process_input(true)
	set_physics_process(true)
	custom_integrator = true
	angular_damp = 10
	$Polygon2D.color = color
	$Polygon2D2.color = color_ready
	$Particles2D.modulate = color


func _input(event):
	if event.is_action_pressed(move_forward):
		speed = max_speed
	elif event.is_action_pressed(move_back):
		speed = -max_speed
	elif event.is_action_pressed(move_left):
		angle_acc = -0.3
	elif event.is_action_pressed(move_right):
		angle_acc = 0.3
	
	elif event.is_action_released(move_forward):
		speed = 0
	elif event.is_action_released(move_back):
		speed = 0
	elif event.is_action_released(move_left) and angle_acc < 0:
		angle_change = 0
		angle_acc = 0
	elif event.is_action_released(move_right) and angle_acc > 0:
		angle_change = 0
		angle_acc = 0


func _physics_process(delta):
	shoot_timer -= delta
	if shoot_timer <= 0:
		$Polygon2D2.color = color_ready
	else:
		$Polygon2D2.color = color_reloading
	
	angle_change += angle_acc
	if angle_change < -3:
		angle_change = -3
	elif angle_change > 3:
		angle_change = 3
	if angle_change != 0:
		angular_velocity = angle_change #* delta # See if this works correctly without delta
	else:
		angular_velocity = 0
	
	accelerate(delta)


func accelerate(delta):
	if speed != 0:
		vel = vel_orig.rotated(rotation) * speed #* delta # See if this works correctly without delta
		apply_impulse(Vector2(), vel)


func _integrate_forces(state):
	if reset:
		state.transform = Transform2D(start_angle, start_pos)
		state.linear_velocity = Vector2()
		reset = false
