@tool
extends Label

signal slide_signal (id: int)
signal completed

@export var run_on_startup = false
@export var lines: Array[Line]

@export var debug_instant = false;

func _ready():
	if lines.size() != 0 && !Engine.is_editor_hint():
		text = ""
		if run_on_startup:
			start_slideshow()

func start_slideshow():
	if Engine.is_editor_hint():
		return
	
	for i in lines:
		var current_line = i
		text = current_line.text
		text = text.replace("{{cap_player_name}}", Global.player_name.to_upper())
		text = text.replace("{{player_name}}", Global.player_name)
		slide_signal.emit(current_line.signal_id)
		await get_tree().create_timer(current_line.time * int(!debug_instant)).timeout
	text = ""
	completed.emit()

func _triggered():
	start_slideshow()

func _on_renamed():
	text = name
