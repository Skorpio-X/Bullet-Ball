extends Node2D

var ball = preload("res://Ball2.tscn")
var projectile = preload("res://Projectile.tscn")
var player1_start_pos = Vector2(130, 360)
var player2_start_pos = Vector2(1150, 360)
var player1_start_angle = 0
var player2_start_angle = PI
var points1 = 0
var points2 = 0
var ball1 = null
var ball2 = null
var game_over = false
var game_time = 180
var max_point_value = 15
var max_points = null


func _ready():
	set_process(true)
	restart()


func _process(delta):
	if Input.is_action_pressed('player1_shoot') and $player1.shoot_timer <= 0:
		create_projectile($player1)
		$player1.shoot_timer = .5
	if Input.is_action_pressed('player2_shoot') and $player2.shoot_timer <= 0:
		create_projectile($player2)
		$player2.shoot_timer = .5
	if game_over and Input.is_action_just_pressed('restart'):
		restart()
	
	var time_left = $Timer.time_left
	var minutes = time_left / 60
	var seconds = fmod(time_left, 60)
#	$time.text = str(round($Timer.time_left))
#	$time.text = str(round(361.5) % 60)
	$time.text = str('%02d : %02d' % [minutes, seconds])
	
	# Debugging label.
#	$debug.text = str($player1.rotation, $player1.vel, $player2.rotation)


func create_projectile(player):
	var projectile_instance = projectile.instance()
	projectile_instance.init(player)
	$projectiles.add_child(projectile_instance)


func create_ball(spawn):
	var ball_instance = ball.instance()
	ball_instance.position = spawn.position
	ball_instance.spawn = spawn
	$balls.add_child(ball_instance)


func restart():
	game_over = false
	create_ball($ball_spawn1)
	create_ball($ball_spawn2)
	points1 = 0
	points2 = 0
	$points1.text = str(points1)
	$points2.text = str(points2)
	$player1.start_pos = player1_start_pos
	$player1.start_angle = player1_start_angle
	$player2.start_pos = player2_start_pos
	$player2.start_angle = player2_start_angle
	$player1.reset = true
	$player2.reset = true
	for projectile in $projectiles.get_children():
		projectile.queue_free()
	$Timer.wait_time = game_time
	$Timer.start()
	$winner.text = ''
	max_points = max_point_value


func _on_goal1_body_entered( body ):
	if $balls.is_a_parent_of(body):
		print('ball %s entered 1 ' % body.spawn)
		points2 += 1
		$points2.text = str(points2)
		create_ball(body.spawn)
		body.queue_free()
		if points2 >= max_points:
			_on_Timer_timeout()
	print('body entered goal 1 ', body)


func _on_goal2_body_entered( body ):
	if $balls.is_a_parent_of(body):
		print('ball %s entered 2 ' % body.spawn)
		points1 += 1
		$points1.text = str(points1)
		create_ball(body.spawn)
		body.queue_free()
		if points1 >= max_points:
			_on_Timer_timeout()
	print('body entered goal 2 ', body)


func _on_Timer_timeout():
	game_over = true
	for ball in $balls.get_children():
		ball.queue_free()
	
	var text = "It's a tie."
	if points1 > points2:
		text = 'Player 1 is the winner!'
	elif points2 > points1:
		text = 'Player2 is the winner!'
	text += '\nPress Enter to restart.'
	$winner.text = text
