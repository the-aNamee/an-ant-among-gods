extends CharacterBody2D

signal begin
signal dies
signal push

const SPEED = 1500.0
const JUMP_VELOCITY = -300.0
const FRICTION = 0.0005
const DEATH_POINT = 332


const SPEAR_SCENE = preload("res://stuff/spear.tscn")
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
var can_pound = false
var is_invicible = false


@export var contrable = false
var respawn_point = global_position


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") && contrable && (is_on_floor() || false):
		velocity.y = JUMP_VELOCITY
	if Input.is_action_just_released("jump") && contrable && velocity.y < 0:
		velocity.y /= 2
	
	if global_position.y > DEATH_POINT:
		die()
	
	
	var speed = SPEED
	if OS.has_feature("debug") && Input.is_action_pressed("ui_right"):
		speed = speed * 10
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right") * int(contrable)
	
	velocity.x += direction * speed * delta
	velocity.x = velocity.x * FRICTION ** delta
	
	
	# Handle animation
	if direction && is_on_floor() && abs(velocity.x) > 30:
		sprite.flip_h = bool(direction - 1)
		animation_player.play("run_right")
	else:
		animation_player.play("idle")

	move_and_slide()


func _start_label_signal(id):
	if id == 1: # Move onto screen.
		velocity.x = 300
		await get_tree().create_timer(0.1).timeout
		contrable = true
		begin.emit()


func _on_hurtbox_body_entered(body):
	die()


func die():
	if is_invicible:
		return
	global_position = respawn_point
	dies.emit()


func _on_hurtbox_area_entered(area):
	#print("Should die")
	if area.is_in_group("hit"):
		die()


func _on_ares_nothing():
	$CanvasLayer.be_ready()


func _on_freeze():
	contrable = false
	sprite.flip_h = false

func pound(to: float):
	global_position.y = to

func pound_to_ground():
	pound(250)
	respawn_point = global_position

func pound_node(mod: float, node: Node2D):
	if "_pounded" in node:
		node._pounded()
	pound(node.global_position.y + mod)
	velocity.y = JUMP_VELOCITY * (3/4 + 1)


func _on_talkin_slide_signal(id):
	if id == 1:
		# Ground pound
		can_pound = true
		velocity.y = JUMP_VELOCITY
		await get_tree().create_timer(0.4).timeout
		pound_to_ground()
		contrable = true
		push.emit()

#func _input(event):
	#if event.is_action_pressed("ui_up"):
		#_on_talkin_slide_signal(1)


func _on_past(node: Node2D):
	print("Exist")
	is_invicible = true
	var mod = 0
	if node.is_in_group("spear"):
		mod = -12
	else:
		mod = -50
	pound_node(mod, node)
	await get_tree().create_timer(0.1).timeout
	is_invicible = false
