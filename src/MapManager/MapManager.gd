extends Node2D

var tiles = []
var units = []

onready var UnitManager = null
onready var MapDisplay = null
onready var MapGrid = null

enum Side {
	ANY,
	LEFT,
	RIGHT
}

func _ready() -> void:
	Global.init_2d_array(tiles, Global.MAP_TILES_WIDTH, Global.MAP_TILES_HEIGHT, Global.Tile.GROUND)
	Global.init_2d_array(units, Global.MAP_TILES_WIDTH, Global.MAP_TILES_HEIGHT)

# ======================================
# Tile
# ======================================

func get_tile(pos: Vector2) -> int:
	return tiles[pos.x][pos.y]

func set_tile(tile_type: int, pos: Vector2) -> bool:
	if (_is_in_bounds(pos)):
		tiles[pos.x][pos.y] = tile_type
		MapDisplay.render(tiles)
		return true
	else:
		return false

# ======================================
# Unit
# ======================================

func get_unit(pos: Vector2) -> Unit:
	return units[pos.x][pos.y]

func set_unit(unit: Unit, pos: Vector2) -> bool:
	if (!unit || _is_in_bounds(pos)):
		return false
		
	var tile_type = get_tile(pos)
	if (_is_traversable_by_unit(tile_type, unit)):
		_clear_unit_position(unit.tile_position)
		unit.tile_position = pos
		UnitManager.move_unit(unit, pos)
		return true
	else:
		return false

func add_unit(unit_type: int, pos: Vector2) -> bool:
	var unit = _instance_unit(unit_type)
	UnitManager.add_child(unit)
	
	if (unit && _is_placable_position(pos)):
		return set_unit(unit, pos)
	else:
		return false

func spawn_unit(unit_type: int, side: int = Side.ANY) -> bool:
	var pos = _get_random_placeable_position(side)
	return add_unit(unit_type, pos)

func _instance_unit(unit_type: int) -> Unit:
	# TODO
	return null

func _clear_unit_position(pos: Vector2) -> void:
	if (_is_in_bounds(pos)):
		units[pos.x][pos.y] = null

func _is_traversable_by_unit(tile_type: int, unit: Unit) -> bool:
	match(tile_type):
		Global.Tile.GROUND:
			return true
		Global.Tile.EMPTY:
			return unit.is_hole_traversing
		Global.Tile.WATER:
			return unit.is_water_traversing
		Global.Tile.FENCE:
			return unit.is_fence_traversing
	return false

# ======================================
# Position Checks
# ======================================

func _get_random_placeable_position(side = Side.ANY) -> Vector2:
	var min_x = 0
	var max_x = Global.MAP_TILES_WIDTH
	
	if (side == Side.LEFT):
		var midpoint = int(floor(Global.MAP_TILES_WIDTH / 2))
		max_x = midpoint
	elif (side == Side.RIGHT):
		var midpoint = int(ceil(Global.MAP_TILES_WIDTH / 2))
		min_x = midpoint
	else: 
		pass # Side.ANY
		
	var pos = Vector2(-1, -1)
	while (!_is_placable_position(pos)):
		var x = min_x + (Global.rng.randi() % (max_x - min_x))
		var y = Global.rng.randi() % Global.MAP_TILES_HEIGHT
		pos = Vector2(x, y)
		# TODO: Infinite loop on full map
	
	return pos

func _is_placable_position(pos: Vector2) -> bool:
	return (_is_in_bounds(pos)
		&& tiles[pos.x][pos.y] == Global.Tile.GROUND
		&& units[pos.x][pos.y] == null)

func _is_in_bounds(pos: Vector2) -> bool:
	return Global.vec2_within_bounds(pos, Global.MAP_TILES_WIDTH, Global.MAP_TILES_HEIGHT)
