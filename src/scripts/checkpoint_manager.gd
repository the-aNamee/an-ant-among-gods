extends Node

@export var player: CharacterBody2D

func _ready():
	for i in get_children():
		i.hide()


func _process(_delta):
	for i: Node2D in get_children():
		if i.global_position.x < player.global_position.x:
			player.respawn_point = i.global_position
			i.queue_free()
			break
