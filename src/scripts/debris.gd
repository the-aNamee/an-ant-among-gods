extends RigidBody2D

@onready var sprite_2d = $Sprite2D

func _ready():
	if Global.difficulty >= Global.IMPOSIBLE:
		set_collision_layer_value(9, true) # 4 is the debris hit layer.
	
	sprite_2d.rotation_degrees = randi_range(0, 4) * 90
	sprite_2d.frame = randi_range(6, 8)


func _on_body_entered(body):
	if body is TileMapLayer:
		queue_free()
