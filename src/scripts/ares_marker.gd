@tool
extends Marker2D

@onready var jump_line = $JumpLine

@export var jump_velocity = -150.0:
	set(new):
		jump_velocity = new
		if Engine.is_editor_hint():
			draw_jump_line.call_deferred()

func _ready():
	if !Engine.is_editor_hint():
		jump_line.hide()

const SPEED = 100
const BOTTOM = 42
const BASE_DELTA = 0.01666666666667
const GRAVITY_MOD = 0.25
const GRAVITY = Vector2.DOWN * 980





func draw_jump_line():
	var pos = Vector2.ZERO  # Start from the character's current position
	var vel = Vector2(-SPEED, jump_velocity)  # Start with initial velocities (horizontal and vertical)
	var time_step = BASE_DELTA  # Use the fixed base delta time
	var gravity = GRAVITY.y * GRAVITY_MOD  # Use the effective gravity
	
	# Loop through the number of points in the jump line
	for i in range(jump_line.points.size()):
		jump_line.points[i] = pos  # Set the current position for the point
		
		# Update the position based on velocity
		pos += vel * time_step
		
		# Apply gravity to the vertical velocity
		vel.y += gravity * time_step
