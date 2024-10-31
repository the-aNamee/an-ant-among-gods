extends RigidBody2D

@onready var animation_tree = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var real_dir = linear_velocity
	real_dir.y = -real_dir.y
	animation_tree.set("parameters/blend_position", real_dir)


func _on_body_entered(body):
	if body.is_in_group("map"):
		queue_free()
