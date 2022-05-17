extends Node

var tiles = []
var tiles_width = 0
var tiles_height = 0

func _init():
	tiles_width = Global.MAP_TILES_WIDTH
	tiles_height = Global.MAP_TILES_HEIGHT
	
	var new_tiles = []
	for x in range(tiles_width):
		new_tiles.append([])
		for y in range(tiles_height):
			new_tiles[x].append(Global.Tile.INVALID)
			
	tiles = new_tiles

func _ready():
	pass

func fill(tile:int = Global.Tile.EMPTY):
	for x in range(tiles_width):
		for y in range(tiles_height):
			tiles[x][y] = tile
