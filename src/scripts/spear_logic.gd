extends Node

@onready var sprite_2d = $"../Sprite2D"
@onready var animation_tree = $"../AnimationTree"
@onready var dad = $".."
@onready var ppos = dad.global_position
@onready var animation_player = $"../AnimationPlayer"
@onready var collision_shape = $"../Collision/RealCollisionShape2D"

var time_alive = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	sprite_2d.global_rotation = 0
	
	var dir = ppos - dad.global_position
	dir.x = -dir.x
	animation_tree.set("parameters/blend_position", dir)
	ppos = dad.global_position
	
	time_alive += delta
	
	collision_shape.rotation = -int(animation_player.current_animation)


func _on_collision_body_entered(body):
	if body.is_in_group("map"):
		Global.spear_time = time_alive
		dad.queue_free()

func _pounded():
	queue_free()
