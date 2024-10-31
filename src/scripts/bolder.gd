extends RigidBody2D


const SPEED = -40
const MIN_SPEED = 150

func _physics_process(delta):
	angular_velocity = SPEED
	$Sprite2d.global_rotation = 0
	if linear_velocity.x > -MIN_SPEED:
		linear_velocity.x = -MIN_SPEED
