extends 'res://Player.gd'

var target_ball = null
onready var direction = Vector2(1, 0).rotated(rotation)


func _ready():
	set_physics_process(true)
	print(direction)

func _physics_process(delta):
	if not target_ball:
		target_ball = get_parent().get_node('balls').get_children()[randi()%2]
		print(target_ball)
	
	# Rotate to target.
	var target_vector = target_ball.position - position
#	print(target_vector)