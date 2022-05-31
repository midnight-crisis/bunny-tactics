extends Node

onready var Map = get_parent().MapManager # TODO: seems sketchy

# ======================================
# Control (Main)
# ======================================

func control_units(units: Array):
	for u in units:
		control_units(u)

func control_unit(unit: Unit):
	
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
				# HURT UNIT
				return
	
	var moveable_tiles = get_moveable_tiles(unit)
	var attackable_units = get_units_in_tiles(moveable_tiles)
	if (attackable_units != []):
		var weakest_unit = pick_weakest_unit(attackable_units)
		if (weakest_unit != null):
			var adjacent_tile = get_reachable_adjacent_tile(unit, weakest_unit.grid_position)
			if (adjacent_tile != null):
				# MOVE TO ADJACENT TILE
				# HURT UNIT
				return
	
	var extremest_tile = pick_extremest_tile(unit.grid_position, moveable_tiles)
	# MOVE UNIT
	
	attackable_tiles = get_attackable_tiles(unit)
	if (attackable_tiles != []):
		attackable_units = get_units_in_tiles(attackable_tiles)
		if (attackable_units != []):
			var weakest_unit = pick_weakest_unit(attackable_units)
			if (weakest_unit != null):
				# HURT UNIT
				return
				
	# WAIT
	pass
	
# ======================================
# Tile 
# ======================================
	
func get_moveable_tiles(unit: Unit) -> Array:
	return get_reachable_tiles(unit, unit.move_reach)
	
func get_attackable_tiles(unit: Unit) -> Array:
	return get_reachable_tiles(unit, unit.attack_reach)

func get_reachable_tiles(unit: Unit, reach: int) -> Array:
	return [null]
	
func get_units_in_tiles(grid_positions: Array) -> Array:
	return []
	
func get_reachable_adjacent_tile(unit: Unit, pos: Vector2) -> Vector2:
	return Vector2(-1, -1)

func pick_extremest_tile(pos: Vector2, grid_positions: Array) -> Vector2:
	return Vector2(-1, -1)
	
# ======================================
# Unit 
# ======================================
	
func pick_weakest_unit(units: Array) -> Unit:
	return null

