extends CanvasLayer

signal talk

@onready var line_edit = $LineEdit


func _ready():
	hide()


func be_ready():
	show()
	line_edit.select()
	line_edit.virtual_keyboard_enabled = true

func _input(event):
	if event.is_action_pressed("enter") && visible:
		_on_submit()


func _on_submit():
	if line_edit.text == "":
		return
	
	hide()
	line_edit.virtual_keyboard_enabled = false
	Global.player_name = line_edit.text
	talk.emit()
