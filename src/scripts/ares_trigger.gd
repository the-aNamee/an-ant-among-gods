extends Area2D

@export_multiline var print = ""
enum ACTION {TALK, STOP_SPEARS, EXIST}
@export var action: ACTION = ACTION.TALK
@export var single_use = false


func _on_body_entered(body):
	if body.is_in_group("ares"):
		match action:
			ACTION.TALK:
				body._say(print)
			ACTION.STOP_SPEARS:
				body._stop_spearing()
		
		if single_use:
			queue_free()
