extends Control


var fire_rate_button_down = false
var fire_rate_button_up = false
var points_button_down = false
var points_button_up = false
var frame = 0


func _ready():
	set_process(true)
	$Player1Button/Label.text = global.player1
	$Player2Button/Label.text = global.player2
	$LabelMaxPoints.text = str(global.max_points)
	$Arena.text = str(global.arena+1)
	$LabelFireRate2.text = str(global.fire_rate)
	$StartButton.grab_focus()


func _process(delta):
	frame += 1
	frame %= 5
	if fire_rate_button_down and frame == 1:
		global.fire_rate -= .1
		global.fire_rate = stepify(max(.1, global.fire_rate), .1)
		$LabelFireRate2.text = str(global.fire_rate)
	elif fire_rate_button_up and frame == 1:
		global.fire_rate += .1
		$LabelFireRate2.text = str(global.fire_rate)
	
	if points_button_up and frame == 1:
		global.max_points += 1
		$LabelMaxPoints.text = str(global.max_points)
	elif points_button_down and frame == 1:
		global.max_points -= 1
		global.max_points = max(1, global.max_points)
		$LabelMaxPoints.text = str(global.max_points)


func _on_change_scene_pressed():
	get_node("/root/global").goto_scene("res://game_scene.tscn")


func _on_Player1Button_pressed():
	var current_text = $Player1Button/Label.text
	var new_text = 'Human'
	if current_text == 'Human':
		new_text = 'AI'
	else:
		new_text = 'Human'
	print(new_text)
	$Player1Button/Label.text = new_text
	global.player1 = new_text


func _on_Player2Button_pressed():
	var current_text = $Player2Button/Label.text
	var new_text = 'Human'
	if current_text == 'Human':
		new_text = 'AI'
	else:
		new_text = 'Human'
	print(new_text)
	$Player2Button/Label.text = new_text
	global.player2 = new_text


func _on_Point_Button_plus_down():
	frame = 0
	points_button_up = true

func _on_Point_Button_up():
	points_button_up = false

func _on_Point_Button_minus_down():
	frame = 0
	points_button_down = true

func _on_Point_Button_minus_up():
	points_button_down = false


func _on_ButtonArena_pressed():
	global.arena += 1
	global.arena %= 3  # Should be len arenas.
	$Arena.text = str(global.arena+1)


func _on_Button2_button_down():
#	global.fire_rate += .1
	frame = 0
	$LabelFireRate2.text = str(global.fire_rate)
	fire_rate_button_up = true

func _on_Button2_fire_rate_button_down():
#	global.fire_rate -= .1
	frame = 0
	$LabelFireRate2.text = str(global.fire_rate)
	fire_rate_button_down = true

func _on_Button_fire_rate_button_up():
	fire_rate_button_up = false

func _on_Button_fire_rate_button_down():
	fire_rate_button_down = false
