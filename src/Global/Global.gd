extends Node

const VERSION = "0.0.12"

const CELL_WIDTH = 16
const CELL_HEIGHT = 16
const MAP_TILES_WIDTH = 12
const MAP_TILES_HEIGHT = 8
const UNIT_VERTICAL_OFFSET = 4

var rng = RandomNumberGenerator.new()

# Ground Altas isn't randomized, Godot Bug
# https://github.com/godotengine/godot/issues/36972
enum Tile {
	INVALID = -1,
	EMPTY = 1,
	GROUND = 0,
	WATER = 2
}

func _ready() -> void:
	rng.randomize()
