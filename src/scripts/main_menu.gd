extends Control



func _on_start(difficulty: int):
	Global.difficulty = difficulty
	get_tree().change_scene_to_file("res://scenes/world.tscn")
