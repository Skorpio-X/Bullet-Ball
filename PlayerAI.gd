extends 'res://Player.gd'

signal fire

var target_ball = null
var target_vector = null
var direction = Vector2(1, 0)
var firing = true
var goal = null
var goal_pos = Vector2(0, 360)
var vector_to_goal = Vector2()
var defense_pos = Vector2()
var vector_to_own_goal = Vector2()
var reflected_vector = Vector2()
var estimated_ball_position = Vector2()
var timer = 0  # Switch ball timer.
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
#		estimated_ball_position = ball.position + ball.linear_velocity  # Previous solution
		
#		vector_to_goal = goal_pos - estimated_ball_position
#		reflected_vector = vector_to_goal.reflect(Vector2(0, 1))
#		var target_vector = ball.position - position
#		var target_vector = estimated_ball_position - position  # Previous solution
		var target_vector = get_target_vector()
		if target_vector:
			target_vector -= position
		
#		target_vector += ball.linear_velocity
#		print(target_vector)
#		var orientation = vector_to_goal.rotated(-PI/2).dot(direction)
#		var orientation = target_vector.rotated(-PI/2).dot(direction)  # Previous solution
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


func get_target_vector():
	var target_pos = target_ball.get_ref().position - position
	var tv = target_ball.get_ref().linear_velocity
	var v = 583  # Projectile speed.
	var tx = target_pos.x
	var ty = target_pos.y
	var dst = target_ball.get_ref().position
	
	var a = tv.x*tv.x + tv.y*tv.y - v*v
	var b = 2 * (tv.x*tx + tv.y*ty)
	var c = tx*tx + ty*ty
	
	var ts = quad(a, b, c)
	
	var sol = null
	
	if ts:
		var t0 = ts[0]
		var t1 = ts[1]
		var t = min(t0, t1)
		if t < 0:
			t = max(t0, t1)
		if t > 0:
			sol = Vector2(dst.x + tv.x * t, dst.y + tv.y * t)
	
	return sol

func quad(a, b, c):
	var sol = null
	if abs(a) < 1e-6:
		if abs(b) < 1e-6:
			sol = [0, 0] if abs(c) < 1e-6 else null
		else:
			sol = [-c/b, -c/b]
	else:
		var disc = b*b - 4*a*c
		if disc >= 0:
			disc = sqrt(disc)
			a = 2*a
			sol = [(-b-disc)/a, (-b+disc)/a]
	
	return sol


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