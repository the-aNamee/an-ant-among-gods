extends Node


const METEOR_SCENE = preload("res://stuff/meteor.tscn")

const PLAYER_OFFSET = Vector2(0, -300)
const RANDOMNESS = Vector2(576*1.5, 25) # The Y pos is the speed randomness.
const ROT_RANDOMNESS = deg_to_rad(25)
const SPEED = 75

@export var player: CharacterBody2D

func _ready():
	$Timer.wait_time = Global.meteor_time
	print($Timer.wait_time)


func _on_timer_timeout():
	for i in range(Global.meteor_multiplayer):
		spawn()

func spawn():
	var base_pos = player.global_position + PLAYER_OFFSET
	var random_offset = Vector2(randi_range(-RANDOMNESS.x, RANDOMNESS.x), 0)
	var pos = base_pos + random_offset
	var speed = SPEED + randi_range(-RANDOMNESS.y, RANDOMNESS.y)
	var direction = deg_to_rad(90) + randf_range(-ROT_RANDOMNESS, ROT_RANDOMNESS)
	var dir_vec2 = Vector2.from_angle(direction)
	var speed_vec2 = dir_vec2 * speed
	
	var new_meteor = METEOR_SCENE.instantiate()
	new_meteor.global_position = pos
	new_meteor.linear_velocity = speed_vec2
	add_child(new_meteor)
