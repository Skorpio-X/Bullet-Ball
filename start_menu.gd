extends Control


func _ready():
	$Player1Button/Label.text = global.player1
	$Player2Button/Label.text = global.player2


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