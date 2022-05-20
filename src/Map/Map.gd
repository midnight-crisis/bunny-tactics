extends Node2D

signal active_tile_changed

onready var MapTiles = $MapTiles
onready var MapGrid = $MapGrid

var tiles = []
var tiles_width = 0
var tiles_height = 0
var active_tile_position = Vector2(-1, -1)

func _init() -> void:
	tiles_width = Global.MAP_TILES_WIDTH
	tiles_height = Global.MAP_TILES_HEIGHT
	
	# Initialize empty tile data
	var new_tiles = []
	for x in range(tiles_width):
		new_tiles.append([])
		for y in range(tiles_height):
			new_tiles[x].append(Global.Tile.INVALID)
	tiles = new_tiles

func _ready() -> void:
	MapGrid.connect("selected_square_changed", self, "_on_active_tile_change")
	MapGrid.generate(Global.MAP_TILES_WIDTH, Global.MAP_TILES_HEIGHT)
	update()
	
func update():
	MapTiles.render(tiles)
	
func set_tile(x, y, tile):
	tiles[x][y] = tile
	update()

func fill(tile:int = Global.Tile.EMPTY):
	for x in range(tiles_width):
		for y in range(tiles_height):
			tiles[x][y] = tile
	update()

func _on_active_tile_change(tile_position):
	active_tile_position = tile_position
	emit_signal("active_tile_changed", tile_position)
