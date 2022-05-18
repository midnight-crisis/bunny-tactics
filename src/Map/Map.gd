extends Node2D

signal active_tile_changed

onready var MapData = $MapData
onready var MapTiles = $MapTiles
onready var MapGrid = $MapGrid

var active_tile_position = Vector2(-1, -1)

func _ready() -> void:
	MapGrid.connect("selected_square_changed", self, "_on_active_tile_change")
	
	MapData.fill(Global.Tile.GROUND)
	MapTiles.render_map_data(MapData)
	MapGrid.generate(Global.MAP_TILES_WIDTH, Global.MAP_TILES_HEIGHT)
	pass 

func _on_active_tile_change(tile_position):
	active_tile_position = tile_position
	emit_signal("active_tile_changed", tile_position)
