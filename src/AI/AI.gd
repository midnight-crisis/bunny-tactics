extends Node

onready var Map = get_parent().MapManager # HACK: seems sketchy

# ======================================
# Control (Main)
# ======================================

func control_units(units: Array) -> void:
	for u in units:
		control_units(u)

func control_unit(unit: Unit) -> void:
	
	# START
	# From current location, find enemies in attack range
		# If enemy(s) found, attack
			# If multiple enemies, attack weakest enemy
			# END
			
	# From current location, find reachable tiles in move range
		# If enemy(s) found, find adjacent tile
		# If adjacent tile found, move to that tile
		# If enemy is in range of that adjacent tile (will probably be), attack 
			# If multiple enemies, attack weakest enemy
			# END
	
	# Find most left/right-most tile ("extremest")
		# If on right side (center inclusive), choose left-most
		# If on left side (center exclusive), choose right-most
	# Move to that left/right-most tile 
	
	# From new location, find enemies in attack range
		# If enemy(s) found, attack
			# If multiple enemies, attack weakest enemy
			# END
	
	# Wait to passive heal
	# END
	
	var attackable_tiles = get_attackable_tiles(unit)
	if (attackable_tiles != []):
		var attackable_units = get_units_in_tiles(attackable_tiles)
		if (attackable_units != []):
			var weakest_unit = pick_weakest_unit(attackable_units)
			if (weakest_unit != null):
				weakest_unit.damage_by_unit(unit)
				return
	
	var moveable_tiles = get_moveable_tiles(unit)
	var attackable_units = get_units_in_tiles(moveable_tiles)
	if (attackable_units != []):
		var weakest_unit = pick_weakest_unit(attackable_units)
		if (weakest_unit != null):
			var adjacent_tile = get_reachable_adjacent_tile(unit, weakest_unit.grid_position)
			if (adjacent_tile != null):
				unit.set_position(adjacent_tile)
				weakest_unit.damage_by_unit(unit)
				return
	
	var extremest_tile = pick_extremest_tile(unit.grid_position, moveable_tiles)
	unit.set_position(extremest_tile)
	
	attackable_tiles = get_attackable_tiles(unit)
	if (attackable_tiles != []):
		attackable_units = get_units_in_tiles(attackable_tiles)
		if (attackable_units != []):
			var weakest_unit = pick_weakest_unit(attackable_units)
			if (weakest_unit != null):
				weakest_unit.damage_by_unit(unit)
				return
				
	unit.passive_heal()
	pass
	
# ======================================
# Reachable Tile 
# ======================================
	
func get_moveable_tiles(unit: Unit) -> Array:
	return get_reachable_tiles(unit, unit.move_reach)
	
func get_attackable_tiles(unit: Unit) -> Array:
	return get_reachable_tiles(unit, unit.attack_reach)

func get_reachable_tiles(unit: Unit, reach: int) -> Array:
	var empty_list = []
	var empty_grid = []
	Global.init_2d_array(empty_grid, Global.MAP_TILES_WIDTH, Global.MAP_TILES_HEIGHT, false)
	return _i_reachable(unit.grid_position, reach, empty_list, empty_grid, unit)

func _i_reachable(pos: Vector2, reach: int, list: Array, grid: Array, unit: Unit): # -> Array:
	# Return when reach is 0
	if (reach <= 0): return list
	
	# Get NESW tiles from pos
	var available_tiles = [
		Vector2(pos.x + 1, pos.y),
		Vector2(pos.x, pos.y + 1),
		Vector2(pos.x - 1, pos.y),
		Vector2(pos.x, pos.y - 1)
	]
	
	# Check if NESW tiles are valid & not marked on grid
	# if so, add to list, mark on grid, iterate on it with 1 less reach
	for p in available_tiles:
		if (Map.is_in_bounds(p)
		&& grid[pos.x][pos.y] == false
		&& Map.is_traversable_by_unit(unit, p)):
			grid[pos.x][pos.y] = true
			list.append(p)
			_i_reachable(p, reach - 1, list, grid, unit)
	
	return list
	
# ======================================
# Tile 
# ======================================
	
func get_units_in_tiles(grid_positions: Array) -> Array:
	var units = []
	for p in grid_positions:
		var unit = Map.units[p.x][p.y]
		if (unit != null):
			units.append(unit)
	return units
	
func get_reachable_adjacent_tile(unit: Unit, pos: Vector2): # -> Vector2:
	var available_tiles = [
		Vector2(pos.x + 1, pos.y),
		Vector2(pos.x, pos.y + 1),
		Vector2(pos.x - 1, pos.y),
		Vector2(pos.x, pos.y - 1)
	]
	
	# Check if NESW tiles are valid and add to an array
	var reachable_tiles = []
	for p in available_tiles:
		if (Map.is_in_bounds(p)
			&& Map.is_traversable_by_unit(unit, p)):
			reachable_tiles.append(p)
	
	# Choose one of those tiles at random
	if (reachable_tiles != []):
		var random_reachable_tile = reachable_tiles[Global.rng.randi() % reachable_tiles.size()]
		return random_reachable_tile
	else:
		return null

func pick_extremest_tile(pos: Vector2, grid_positions: Array): # -> Vector2:
	var midpoint: float = Global.MAP_TILES_WIDTH * Global.AI_DIRECTION_BIAS
	
	var extremest_tile = grid_positions[0]
	if (pos.x < midpoint): # Moving right
		for p in grid_positions:
			if (extremest_tile.x < p.x):
				extremest_tile = p
	else: # Moving left
		for p in grid_positions:
			if (extremest_tile.x > p.x):
				extremest_tile = p
	
	return extremest_tile
	
# ======================================
# Unit 
# ======================================
	
func pick_weakest_unit(units: Array) -> Unit:
	if (units == [] || units == null): 
		return null
		
	var weakest_unit = units[0]
	for u in units:
		if (u.get_health() < weakest_unit.get_health()):
			weakest_unit = u
	return weakest_unit

