@tool
extends Node2D

const TILE_SIZE = Vector2i(16, 16)

@onready var line_2d = $Line2D

@export var size: Vector2i = Vector2i(3, 3):
	set(new_size):
		if Engine.is_editor_hint():
			new_size.x = max(new_size.x, 1)
			new_size.y = max(new_size.y, 1)
			
			$Line2D.points[0] = Vector2.ZERO
			$Line2D.points[1] = Vector2(Vector2i.RIGHT * TILE_SIZE * new_size)
			$Line2D.points[2] = Vector2(TILE_SIZE * new_size)
			$Line2D.points[3] = Vector2(Vector2i.DOWN * TILE_SIZE * new_size)
			$Line2D.points[4] = Vector2.ZERO
		size = new_size

@export var activated = false
@export var sub = false
@export var no_shake = false

func _ready():
	if !Engine.is_editor_hint():
		line_2d.hide()
		if activated:
			create_crater.call_deferred()
		if Global.DEBUG_START_WITH_CRATERS && OS.has_feature("debug"):
			create_crater.call_deferred()

func _process(delta):
	position = position.snapped(TILE_SIZE)

func _triggered():
	create_crater()

func create_crater():
	var parent: Node = $".."
	if !"main_tilemap" in parent || !"craters_tilemap" in parent || !"camera" in parent:
		return
	var main_tilemap: TileMapLayer = parent.main_tilemap
	var craters_tilemap: TileMapLayer = parent.craters_tilemap
	
	if sub:
		craters_tilemap = parent.sub_tiles
	
	var start_cell = Vector2i(global_position) / TILE_SIZE
	print(start_cell)
	for x in range(start_cell.x, start_cell.x + size.x):
		for y in range(start_cell.y, start_cell.y + size.y):
			var pos = Vector2i(x, y)
			var cell_source_id = craters_tilemap.get_cell_source_id(pos)
			var cell_atlas_coords = craters_tilemap.get_cell_atlas_coords(pos)
			main_tilemap.set_cell(pos, cell_source_id, cell_atlas_coords)
	var camera = parent.camera
	
	if !no_shake:
		camera._quick_shake()
