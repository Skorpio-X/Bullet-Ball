extends 'res://Player.gd'

signal fire

var target_ball = null
var direction = Vector2(1, 0)
var firing = true
var goal = null
var goal_pos = Vector2(0, 360)
var vector_to_goal = Vector2()
var reflected_vector = Vector2()
var estimated_ball_position = Vector2()


# Doesn't get called if the script is swapped out later.
func _ready():
	set_physics_process(true)
	direction.rotated(rotation)


func _physics_process(delta):
	update()
#	speed = 0
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
		vector_to_goal = goal_pos - estimated_ball_position
		reflected_vector = vector_to_goal.reflect(Vector2(0, 1))
#		var target_vector = ball.position - position
#
#		target_vector += ball.linear_velocity
#		print(target_vector)
		var orientation = vector_to_goal.rotated(-PI/2).dot(direction)
	#	print(orientation)
		if orientation < 0:
			angle_change = -angle_speed
		elif orientation > 0:
			angle_change = angle_speed
		
		direction = Vector2(1, 0).rotated(rotation)
		
		if firing:
			emit_signal('fire')
