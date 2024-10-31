extends Node

const OFFSET_FROM_TARGET = 576
const RANDOM_OFFSET = 50

@export var target: Node2D
@onready var path_follower = $PathFollower
@onready var bolder_spawn_pos = $PathFollower/BolderSpawnPos
@onready var timer = $Timer
const BOLDER_SCENE = preload("res://stuff/bolder.tscn")

func _ready():
	timer.wait_time = Global.bolder_speed

func _process(delta):
	path_follower.global_position.x = target.global_position.x + OFFSET_FROM_TARGET
	bolder_spawn_pos.global_position = path_follower.get_collision_point()


func _begain():
	timer.start()
	print("Begain")

func _end():
	timer.stop()


func _spawn():
	var new_bolder = BOLDER_SCENE.instantiate()
	new_bolder.global_position = bolder_spawn_pos.global_position + Vector2.UP * randi_range(-RANDOM_OFFSET, RANDOM_OFFSET)
	add_child(new_bolder)


func _destroy_barrel(body):
	body.queue_free()
