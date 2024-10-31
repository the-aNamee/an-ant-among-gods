extends CharacterBody2D

signal nothing
signal freeze
signal done

#@onready var movement_timer = $MovementTimer
@onready var appearance_timer = $AppearanceTimer
@onready var spear_timer = $SpearTimer
@onready var jump_line = $JumpLine
@onready var sprite = $Sprite
@onready var talkin = $RealTalkin
@onready var side_talkin = $SideTalkin
@export var player: CharacterBody2D
const SPEAR_SCENE = preload("res://stuff/test_spear.tscn")

@export var start_right_away = false
@export var record = false
const SPEED = 0
var JUMP_VELOCITY = -150.0
const BOTTOM = 42
const FRICTION = 0.0005
const BASE_DELTA = 0.01666666666667
const GRAVITY_MOD = 0.25
const PLAYER_SPEEDUP_DIST = 220
const SPEEDUP_SPEED = 150
var PROJECTIOL_GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity") * 0.25 * 0 + 50
const PROJECTIOL_SPEED = 4
var path = PackedVector2Array([])
var path_point = 0
var chasing = false
var done_moving = false
var fighting = false
var really_fighting = false
@onready var px = global_position.x
@onready var start_pos = global_position

func _ready():
	talkin.text = ""
	side_talkin.text = ""
	if start_right_away && true:
		_appear_triggered()
	if !record:
		var file = FileAccess.open("res://assets/ares_path.pv2a", FileAccess.READ)
		if file:
			var byte_array: PackedByteArray = file.get_buffer(file.get_length())
			path = to_packedvector2array(byte_array)
			#path.reverse()
			file.close()
		else:
			push_error("No file found.")
	spear_timer.wait_time = Global.spear_throw_time

func _physics_process(delta):
	if record:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta * GRAVITY_MOD
		
		var direction = 0
		if !appearance_timer.is_stopped():
			direction = -1
		if chasing:
			direction = -1
		
		JUMP_VELOCITY = get_local_mouse_position().y - 150
		
		
		if Input.is_action_just_pressed("ui_up"):
			var file = FileAccess.open("res://assets/new_ares_path.pv2a", FileAccess.WRITE)
			var byte_array = path.to_byte_array()
			file.store_buffer(byte_array)
			file.close()
			print("Saved path.")
		
		
		
		
		 #Handle jump.
		#if Input.is_action_pressed("jump") and is_on_floor():
			#jump_line.show()
			#direction = 0
			#draw_jump_line()
		#if Input.is_action_just_released("jump") and is_on_floor(): 
			#jump_line.hide()
			#velocity.y = JUMP_VELOCITY
		##print("Gravity:", get_gravity())
		
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		
		px = global_position.x
		
		move_and_slide()
		
		if global_position.x < px:
			path.append(global_position)
	elif !done_moving:
		global_position = path[path_point]
		
		if (chasing || !appearance_timer.is_stopped()) && !done_moving:
			var speed = Global.ares_speed
			if player.global_position.x + PLAYER_SPEEDUP_DIST < global_position.x:
				speed = SPEEDUP_SPEED
			
			path_point += delta * speed
			if path_point >= path.size():
				done_moving = true
				velocity = Vector2.ZERO
				path_point = path.size() - 1
				$Attack.queue_free()
			
			if !appearance_timer.is_stopped() && global_position.x < 10239:
				appearance_timer.stop()
				$Talkin.start_slideshow()
	else:
		if not is_on_floor():
			velocity += get_gravity() * delta
		velocity.x = velocity.x * FRICTION ** delta
		
		if player.global_position.x > global_position.x:
			sprite.scale.x = -1
		else:
			sprite.scale.x = 1
		
		if really_fighting:
			if spear_timer.is_stopped():
				spear_timer.start()
			
			if is_on_floor() && randf() < 0.01:
				# Jump
				velocity = Vector2(1000, -200)
				if randf() < 0.5:
					velocity.x = -velocity.x
		
		
		
		move_and_slide()
		

func draw_jump_line():
	var pos = Vector2.ZERO  # Start from the character's current position
	var vel = Vector2(-SPEED, JUMP_VELOCITY)  # Start with initial velocities (horizontal and vertical)
	var time_step = BASE_DELTA  # Use the fixed base delta time
	var gravity = get_gravity().y * GRAVITY_MOD  # Use the effective gravity
	
	# Loop through the number of points in the jump line
	for i in range(jump_line.points.size()):
		jump_line.points[i] = pos  # Set the current position for the point
		
		# Update the position based on velocity
		pos += vel * time_step
		
		# Apply gravity to the vertical velocity
		vel.y += gravity * time_step

func _jump(strength):
	velocity.y = strength

func _appear_triggered():
	appearance_timer.start()


func _on_label_slide_signal(id):
	if id == 1:
		chasing = true
		spear_timer.start()
		Global.going_back = true


func _on_player_dies():
	if chasing:
		path_point = 0
		talkin.text = ""
		side_talkin.text = ""


func to_packedvector2array(input: PackedByteArray):
	var output := PackedVector2Array()
	for i in range(0, input.size(), 8):
		var vec := Vector2(input.decode_float(i), input.decode_float(i + 4))
		output.append(vec)
	return output

func _say(to_say):
	talkin.text = to_say
	
	if to_say == "\"You are NOTHING!!\"":
		freeze.emit()
		talkin.text = ""
		side_talkin.text = "\"You\""
		await get_tree().create_timer(0.5).timeout
		side_talkin.text = "\"You\""
		await get_tree().create_timer(0.5).timeout
		side_talkin.text = "\"are\""
		await get_tree().create_timer(0.5).timeout
		side_talkin.text = "\"NOTHING!!\""
		await get_tree().create_timer(0.5).timeout
		side_talkin.text = ""
		nothing.emit()

func _stop_spearing():
	spear_timer.stop()

func _on_spear_timer_timeout():
	# Instantiate a new spear
	var new_spear = SPEAR_SCENE.instantiate()
	var start_pos = global_position
#	
	# new position = current position + (velocity × time)
	var end_pos = (player.global_position.x + player.velocity.x * Global.spear_time) * Vector2.RIGHT
	end_pos.y = player.global_position.y
	end_pos += Vector2.from_angle(deg_to_rad(randf_range(-180, 180))) * randf_range(0, 150)
	
	if really_fighting:
		end_pos = player.global_position
	
	new_spear.launch(start_pos, end_pos, PROJECTIOL_GRAVITY, PROJECTIOL_SPEED)
	get_parent().add_child(new_spear)


func _on_player_push():
	velocity = Vector2(1000, -100)
	really_fighting = true


func _pounded():
	done.emit()
	get_tree().paused = true
