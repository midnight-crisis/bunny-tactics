extends Node

var unit = null
var map = []
var units = []

const v0 = Vector2(0,0)
const vM = Vector2(Global.MAP_TILES_WIDTH, Global.MAP_TILES_HEIGHT)

func _ready() -> void:
	pass
	
func control(unit, map):
	# Start
	# Update active unit, current map, current unit placement
	# Find any enemies in attack range
		# If so, attack 
	# Calculate accessible tiles
	# Find the closest enemy
		# If enemy is found, set any accessible tile around it as move target
		# If no enemy is found, set random accessible move target (bad)
	# If still not attacked, find any enemies in attack range
		# If so, attack 
		# If not, wait (passive heal)
	# End
	
	print("Starting AI for " + String(unit.species))
	
		
	pass
	
func get_reachable_tiles(pos, reach):
	var tiles = _calcR(pos, reach)
	
	for i in range(0, tiles.size()):
		for j in range(tiles.size() - 1, i):
			if (tiles[i] == tiles[j]):
				tiles.pop_at(j)
	return tiles
	
func get_reachable_units():
	pass

func _calcR(pos, reach):
	if (reach == 0): return []
	
	var reachable = []
	var targets = [
		Vector2(pos.x, pos.y + 1),
		Vector2(pos.x + 1, pos.y),
		Vector2(pos.x, pos.y - 1),
		Vector2(pos.x - 1, pos.y)
	]
	
	# Add NESW if eligible
	# Reiterate at NESW with 1 less reach
	for t in targets:
		if (t >= v0 && t < vM
		&& (map[pos.x][pos.y] == Global.Tile.GROUND
		|| (map[pos.x][pos.y] == Global.Tile.EMPTY && unit.can_traverse_holes)
		|| (map[pos.x][pos.y] == Global.Tile.WATER && unit.can_traverse_water)
		|| (map[pos.x][pos.y] == Global.Tile.FENCE && unit.can_traverse_fence))):
			reachable.append(t)
			reachable.append_array(_calcRT(t, reach - 1))
	
	return reachable

