extends Node

const VERSION = "0.0.7"

const CELL_WIDTH = 16
const CELL_HEIGHT = 16
const MAP_TILES_WIDTH = 12
const MAP_TILES_HEIGHT = 8
const UNIT_VERTICAL_OFFSET = 4

var rng = RandomNumberGenerator.new()

enum Tile {
	INVALID = -1,
	EMPTY = 0,
	GROUND = 1
}

func _ready() -> void:
	rng.randomize()
