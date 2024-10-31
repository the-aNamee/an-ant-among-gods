extends Sprite2D

@onready var timer = $Timer

var stage = 0
var stages = [randi_range(1, 3), randi_range(1, 3), 4, 5]

func _ready():
	rotation_degrees = randi_range(0, 4) * 90
	frame = randi_range(1, 3)

func _process(delta):
	pass


func _on_timer_timeout():
	if stage >= stages.size():
		queue_free()
		return
	
	frame = stages[stage]
	stage += 1
