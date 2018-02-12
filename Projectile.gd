extends RigidBody2D


func _ready():
	set_process(true)


func init(player):
	var vec = Vector2(400, 0).rotated(player.rotation)
	linear_velocity = vec
	position = player.position + vec / 6
	rotation = player.rotation
	$Polygon2D.color = player.get_node('Polygon2D').color


func _process(delta):
	if get_colliding_bodies():
		queue_free()
