extends RigidBody2D

@onready var particle_timer = $ParticleTimer
const PARTICLE_SCENE = preload("res://stuff/meteor_particle.tscn")
const DEBRIS_SCENE = preload("res://stuff/debris.tscn")

const PARTICLE_RANDOMNESS = 6
const DEBRIS_SPEED = Vector2(20, -50)

var real_velocity: Vector2


func _ready():
	real_velocity = linear_velocity

func _physics_process(delta):
	linear_velocity = real_velocity
	
	if global_position.y > 400:
		queue_free()


func _on_particle_timer_timeout():
	var partical_dir = Vector2.from_angle(randf_range(0, deg_to_rad(360)))
	var partical_offset = partical_dir * randf_range(0, PARTICLE_RANDOMNESS)
	var partical_pos = (global_position + partical_offset).round()
	var new_partical = PARTICLE_SCENE.instantiate()
	new_partical.global_position = partical_pos
	get_parent().add_child(new_partical)


func _on_body_entered(body):
	if body.is_in_group("detached"):
		return
	
	if !is_offscreen():
		spawn_debris.call_deferred(1)
		spawn_debris.call_deferred(-1)
	queue_free()

func spawn_debris(dir):
	var new_debris = DEBRIS_SCENE.instantiate()
	new_debris.global_position = global_position
	new_debris.linear_velocity = DEBRIS_SPEED
	new_debris.linear_velocity.x *= dir
	get_parent().add_child(new_debris, true)

func is_offscreen():
	var viewport_rect = get_viewport_rect()
	var top_left_of_screen = get_viewport().get_camera_2d().global_position - viewport_rect.get_center()
	var pos = global_position - top_left_of_screen
	return !viewport_rect.has_point(pos)
