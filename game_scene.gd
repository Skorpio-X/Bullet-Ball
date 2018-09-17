extends Node2D


var ball = preload("res://Ball2.tscn")
var projectile = preload("res://Projectile.tscn")
var map1 = preload("res://map1.tscn")
var map2 = preload("res://map2.tscn")
var map3 = preload("res://map3.tscn")
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
var max_point_value = global.max_points
var max_points = null
var maps = [map1, map2, map3]
var map = maps[global.arena].instance()
var map_index = 0
var human_script = preload("res://Player.gd")
var ai_script = preload("res://PlayerAI.gd")


func _ready():
	set_process(true)
	map.name = 'map'  # Change the name to access the node with $ later.
	add_child(map, true)
	move_child($map, 0)
	# Connect the goals.
	$map/goal1.connect('body_entered', self, '_on_goal1_body_entered')
	$map/goal2.connect('body_entered', self, '_on_goal2_body_entered')
	if global.player1 == 'AI':
#		print($player1.get_script(), ai_script)
		$player1.set_script(ai_script)
		$player1.connect('fire', self, '_on_player1_fire')
		$player1.goal = $map/goal2
		$player1.defense_pos = $map/defense_pos_1.position
	if global.player2 == 'AI':
		$player2.set_script(ai_script)
		$player2.connect('fire', self, '_on_player2_fire')
		$player2.goal = $map/goal1
		$player2.defense_pos = $map/defense_pos_2.position
		$player2.color_ready = '00a5ff'
		$player2.color_reloading = '002662'
	restart()


func _process(delta):
	update()
	if Input.is_action_pressed('player1_shoot') and $player1.shoot_timer <= 0:
		create_projectile($player1)
		$player1.shoot_timer = $player1.shoot_time
		$shoot_sound2.play()
		$shoot_sound3.play()
	if Input.is_action_pressed('player2_shoot') and $player2.shoot_timer <= 0:
		create_projectile($player2)
		$player2.shoot_timer = $player2.shoot_time
		$shoot_sound2.play()
		$shoot_sound3.play()
	if Input.is_action_just_pressed('ui_focus_next'):
		# Remove the previous map.
		map.queue_free()
		remove_child(map)
		for ball in $balls.get_children():
			ball.queue_free()
		# Increment map index.
		map_index += 1
		map_index %= len(maps)
		# Add the new map.
		map = maps[map_index].instance()
		map.name = 'map'
		add_child(map, true)
		move_child($map, 0)
		$map/goal1.connect('body_entered', self, '_on_goal1_body_entered')
		$map/goal2.connect('body_entered', self, '_on_goal2_body_entered')
		restart()
	if Input.is_action_pressed('ui_cancel'):
		get_node("/root/global").goto_scene("res://start_menu.tscn")
		
	if game_over and Input.is_action_just_pressed('restart'):
		restart()
	
	var time_left = $Timer.time_left
	var minutes = time_left / 60
	var seconds = fmod(time_left, 60)
	$time.text = str('%02d:%02d' % [minutes, seconds])
	
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
	create_ball($map/ball_spawn1)
	create_ball($map/ball_spawn2)
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
	$player1.shoot_timer = 0
	$player2.shoot_timer = 0
	for projectile in $projectiles.get_children():
		projectile.queue_free()
	$Timer.wait_time = game_time
	$Timer.start()
	$winner.text = ''
	max_points = max_point_value


func _on_goal1_body_entered( body ):
	if $balls.is_a_parent_of(body):
		$goal_sound.play()
		points2 += 1
		$points2.text = str(points2)
		create_ball(body.spawn)
		body.queue_free()
		$AnimationPlayer.play("shake")
		if points2 >= max_points:
			_on_Timer_timeout()


func _on_goal2_body_entered( body ):
	if $balls.is_a_parent_of(body):
		$goal_sound.play()
		points1 += 1
		$points1.text = str(points1)
		create_ball(body.spawn)
		body.queue_free()
		$AnimationPlayer.play("shake")
		if points1 >= max_points:
			_on_Timer_timeout()


func _on_Timer_timeout():
	$Timer.stop()
#	game_over = true
	$DelayTimer.start()
	for ball in $balls.get_children():
		ball.queue_free()
	
	var text = "It's a tie."
	if points1 > points2:
		text = 'Player 1 is the winner!'
	elif points2 > points1:
		text = 'Player2 is the winner!'
	text += '\nPress Enter to restart.'
	$winner.text = text


func _on_DelayTimer_timeout():
	game_over = true


func _on_player1_fire():
	if $player1.shoot_timer <= 0:
		create_projectile($player1)
		$player1.shoot_timer = $player1.shoot_time
		$shoot_sound2.play()
		$shoot_sound3.play()


func _on_player2_fire():
	if $player2.shoot_timer <= 0:
		create_projectile($player2)
		$player2.shoot_timer = $player2.shoot_time
		$shoot_sound2.play()
		$shoot_sound3.play()


#func _draw():
##	draw_line($player2.estimated_ball_position, $player2.estimated_ball_position+$player2.vector_to_goal, 'ffffff')
##	draw_line($player2.estimated_ball_position, $player2.estimated_ball_position+$player2.reflected_vector, 'ff6600')
##	draw_line($player2.position, Vector2(100, 200), '00ff55')
#	if $player2.target_vector:
#		draw_line($player2.target_vector, $player2.position, 'ff6600')
