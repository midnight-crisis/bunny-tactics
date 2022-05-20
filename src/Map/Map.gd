extends Node2D

signal active_tile_changed

onready var MapTiles = $MapTiles
onready var MapGrid = $MapGrid

var tiles = []
var active_tile_position = Vector2(-1, -1)

func _init() -> void:
	for x in range(Global.MAP_TILES_WIDTH):
		tiles.append([])
		for y in range(Global.MAP_TILES_HEIGHT):
			tiles[x].append(Global.Tile.INVALID)

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
	for x in range(Global.MAP_TILES_WIDTH):
		for y in range(Global.MAP_TILES_HEIGHT):
			tiles[x][y] = tile
	update()

func _on_active_tile_change(tile_position):
	active_tile_position = tile_position
	emit_signal("active_tile_changed", tile_position)
