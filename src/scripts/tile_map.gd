extends TileMapLayer





func _on_player_begin():
	set_cell(Vector2i(-1, 15), 0, Vector2i(1, 1))
