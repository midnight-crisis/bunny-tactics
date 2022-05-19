extends Node

const VERSION = "0.0.15"

const WINDOW_WIDTH = 320
const WINDOW_HEIGHT = 180
const CAMERA_Y_OFFSET = 48
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

enum ActionType {
	INVALID = -1,
	NONE = 0,
	ATTACK = 1,
	MOVE = 2,
	WAIT = 3,
	SPECIAL_NONE = 10
	BUILD = 11,
	DIG = 12,
	FLOOD = 13,
	HEAL = 14
}

func _ready() -> void:
	rng.randomize()
