extends Node

const MAP_W = 20
const MAP_H = 12
const MAP_TILE = {
	EMPTY = 0,
	GROUND = 1
}

var tiles = []

func _ready() -> void:
	init_map()
	fill_map(1)
	pass
	
func init_map():
	fill_map(0)
			
func fill_map(tile: int = 0):
	for x in range(MAP_W):
		tiles[x] = []
		for y in range(MAP_H):
			tiles[x][y] = tile
