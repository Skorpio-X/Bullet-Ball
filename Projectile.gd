extends RigidBody2D


var collision_particles = preload("res://collision_particles.tscn")
var color = null


func _ready():
	set_process(true)


func init(player):
	var vec = Vector2(500, 0).rotated(player.rotation)
	linear_velocity = vec
	position = player.position + vec / 6
	rotation = player.rotation
	var color = player.get_node('Polygon2D').color
	$Polygon2D.color = color
	self.color = color


func _process(delta):
	if get_colliding_bodies():
		var particles = collision_particles.instance()
		particles.emitting = true
		particles.position = position
		particles.modulate = self.color
		$'..'.add_child(particles)
		get_node('../../explosion_sound2').play()
		queue_free()
