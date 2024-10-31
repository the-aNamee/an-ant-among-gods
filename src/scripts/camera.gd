extends Camera2D

@onready var timer = $Timer
@export var target: Node2D

const SHAKE_INTENSITY = 2

var shaking = false
var target_pos = Vector2.ZERO

func _ready():
	global_position = target.global_position
	target_pos = global_position
	

func _process(delta):
	#if !target:
		#return
	target_pos += (target.global_position - target_pos) * 5 * delta
	var real_shake_intensitiy = SHAKE_INTENSITY * int(shaking) + 2 * SHAKE_INTENSITY * int(!timer.is_stopped())
	#print(real_shake_intensitiy)
	#print(int(!timer.is_stopped()))
	#print(SHAKE_INTENSITY + int(!timer.is_stopped()))
	#print(shaking) 
	global_position = target_pos + real_shake_intensitiy * Vector2(randf_range(-1, 1), randf_range(-1, 1))


func _on_shake_trigger():
	shaking = true

func _on_shake_end_trigger():
	shaking = false

func _quick_shake():
	#print("Quickshakin")
	timer.start()


func _on_player_push():
	limit_right = 576
