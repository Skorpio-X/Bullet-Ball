extends 'res://Player.gd'

signal fire

var target_ball = null
var direction = Vector2(1, 0)
var firing = true
var goal = null
var goal_pos = Vector2(0, 360)
var vector_to_goal = Vector2()
var defense_pos = Vector2()
var vector_to_own_goal = Vector2()
var reflected_vector = Vector2()
var estimated_ball_position = Vector2()
var timer = 0
var ball_index = 0
var adjust_position = false


# Doesn't get called if the script is swapped out later.
func _ready():
	set_physics_process(true)
	direction.rotated(rotation)

func _input(event):
	pass

func _physics_process(delta):
	timer += delta
	# Switch target.
	if timer >= 1:
		timer = 0
		ball_index += 1
		ball_index %= 2
		var balls = get_parent().get_node('balls').get_children()
		if balls:
			target_ball = weakref(balls[ball_index])

	# Have to check both because I can't set target_ball to a weak ref by default.
	if not target_ball or not target_ball.get_ref():
		var balls = get_parent().get_node('balls').get_children()
#		print('balls ', balls)
		if balls:
			target_ball = weakref(balls[randi()%2])
#			print(target_ball)
		else:
			angle_change = 0
	else:
		# Rotate to target.
		var ball = target_ball.get_ref()
		estimated_ball_position = ball.position + ball.linear_velocity
		
#		vector_to_goal = goal_pos - estimated_ball_position
#		reflected_vector = vector_to_goal.reflect(Vector2(0, 1))
#		var target_vector = ball.position - position
		var target_vector = estimated_ball_position - position
#
#		target_vector += ball.linear_velocity
#		print(target_vector)
#		var orientation = vector_to_goal.rotated(-PI/2).dot(direction)
		var orientation = target_vector.rotated(-PI/2).dot(direction)
	#	print(orientation)
		if orientation < 0:
			angle_change = -angle_speed
		elif orientation > 0:
			angle_change = angle_speed
		
		direction = Vector2(1, 0).rotated(rotation)
		
		if firing:
			emit_signal('fire')
			
	move(delta)


func move(delta):
	# Adjust position.
	if defense_pos.distance_to(position) > 150:
		# Rotate to goal pos.
		vector_to_own_goal = defense_pos - position
		var orientation = vector_to_own_goal.rotated(-PI/2).dot(direction)
		if orientation < 0:
			angle_change = angle_speed
		elif orientation > 0:
			angle_change = -angle_speed
		speed = 200
		vel = vel_orig.rotated(rotation) * speed * delta
		apply_impulse(Vector2(), -vel)


func accelerate(delta):
	pass
#	if speed != 0:
#		vel = vel_orig.rotated(rotation) * speed * delta
#		apply_impulse(Vector2(), vel)