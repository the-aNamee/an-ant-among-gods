extends Node

signal past(Node2D)

@export var player: Node2D
@onready var ares = $Ares
var p_player_pos = Vector2.ZERO
var num_interpolations = 10  # Number of steps to interpolate between frames

var spear_previous_positions := {}  # Dictionary to store previous positions of spears

func _process(_delta):
	if !ares.really_fighting:
		return
	
	var all_spears: Array[Node2D] = []
	for i in get_children():
		if i.is_in_group("spear") or i.is_in_group("ares"):
			all_spears.append(i)
	
	# Loop through each spear and check if player crossed it
	for spear in all_spears:
		var spear_prev_pos = spear_previous_positions.get(spear, spear.global_position)  # Get previous position or default to current
		
		# Ensure the player is above the spear in the Y-axis
		if player.global_position.y < spear.global_position.y:
			var sign_a = sign(player.global_position.x - spear.global_position.x)  # Sign of player's position relative to spear's current position
			var sign_b = sign(p_player_pos.x - spear_prev_pos.x)  # Sign of player's previous position relative to spear's previous position
			
			if sign_a != sign_b:
				past.emit(spear)
		
		# Update the previous position for this spear
		spear_previous_positions[spear] = spear.global_position
	
	# Update player's previous position
	p_player_pos = player.global_position
