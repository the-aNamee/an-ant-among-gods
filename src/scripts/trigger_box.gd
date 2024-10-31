extends Area2D

signal trigger

@export var one_time = true
@export var back = false

var triggered = false

func _on_body_entered(body):
	if body.is_in_group("player") && (!triggered || !one_time) && back == Global.going_back:
		trigger.emit()
		triggered = true


func _ready():
	var parent = get_parent()
	if parent.is_in_group("triggerable"):
		trigger.connect(parent._triggered)
	var thing = PackedVector2Array([Vector2.ZERO])
