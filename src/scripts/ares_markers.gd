extends Node



@export var ares: Node2D

func _process(delta):
	for marker: Node2D in get_children():
		if marker.global_position >= ares.global_position:
			ares._jump(marker.jump_velocity)
			marker.queue_free()
