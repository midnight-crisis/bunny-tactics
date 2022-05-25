extends Node
class_name AI

signal attack
signal move
signal wait

var unit = null
var map = []
var units = []
var attack_target = null
var move_target = null

onready var AttackTimer = $AttackTimer
onready var WaitTimer = $WaitTimer
onready var MoveTimer = $MoveTimer

func _ready() -> void:
	print("Initializing AI...")
	AttackTimer.connect("timeout", self, "_attack")
	WaitTimer.connect("timeout", self, "_wait")
	MoveTimer.connect("timeout", self, "_move")
	
func control(unit_, map_, units_):
	# Start
	# Update active unit, current map, current unit placement
	# Find any enemies in attack range
		# If so, attack 
	# Calculate accessible tiles
	# Find the closest enemy within reachable tiles
		# If enemy is found, set any accessible tile around it as move target
		# If no enemy is found, set random accessible move target (bad)
	# If still not attacked, find any enemies in attack range
		# If so, attack 
		# If not, wait (passive heal)
	# End
	
	unit = unit_
	map = map_
	units = units_
	attack_target = null
	move_target = null
	
	print("Starting AI for " + String(unit.species))
	
	var attack_tiles = get_reachable_tiles(unit.tile_position, unit.attack_reach)
	var move_tiles = get_reachable_tiles(unit.tile_position, unit.move_reach)
	
	attack_target = pick_attack_target(attack_tiles)
	if (attack_target != null):
		AttackTimer.start(Global.AI_MOVE_TIME + Global.AI_ACTION_TIME)
		return
		
	attack_target = pick_attack_target(move_tiles)
	if (attack_target):
		move_target = pick_accessible_adjacent_tile(move_tiles, attack_target.tile_position)
		if (move_target):
			MoveTimer.start(Global.AI_MOVE_TIME)
			AttackTimer.start(Global.AI_MOVE_TIME + Global.AI_ACTION_TIME)
			return
			
	else: # No unit in sight
		if (move_tiles.size() > 0):
			move_target = move_tiles[Global.rng.randi() % move_tiles.size()]
			if (move_target): MoveTimer.start(Global.AI_MOVE_TIME)
		WaitTimer.start(Global.AI_MOVE_TIME + Global.AI_ACTION_TIME)
	
	print("Ending AI")
	
func pick_accessible_adjacent_tile(tiles, pos):
	var targets = [
		Vector2(pos.x, pos.y + 1),
		Vector2(pos.x + 1, pos.y),
		Vector2(pos.x, pos.y - 1),
		Vector2(pos.x - 1, pos.y)
	]
	
	for a in targets:
		if (tiles.has(a)):
			return a
	return null
	
func pick_attack_target(tiles):
	for t in tiles:
		var u = units[t.x][t.y]
		if (u != null && u.team != unit.team):
			return u
	return null

func get_reachable_tiles(pos, reach):
	var tiles = _calcTile(pos, reach)
	
	for i in range(0, tiles.size()):
		for j in range(tiles.size() - 1, i):
			if (tiles[i] == tiles[j]):
				tiles.pop_at(j)
	return tiles

func _move():
	emit_signal("move", unit, move_target)

func _attack():
	emit_signal("attack", unit, attack_target)

func _wait():
	emit_signal("wait", unit)

func _calcTile(pos, reach):
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
		if (_vIn(t)
		&& (map[t.x][t.y] == Global.Tile.GROUND
		|| (map[t.x][t.y] == Global.Tile.EMPTY && unit.can_traverse_holes)
		|| (map[t.x][t.y] == Global.Tile.WATER && unit.can_traverse_water)
		|| (map[t.x][t.y] == Global.Tile.FENCE && unit.can_traverse_fence))): # CHANGE THIS TO FENCE
			reachable.append(t)
			reachable.append_array(_calcTile(t, reach - 1))
	
	return reachable

func _vIn(v):
	if ((v.x >= 0 && v.x < Global.MAP_TILES_WIDTH) &&
		(v.y >= 0 && v.y < Global.MAP_TILES_HEIGHT)): return true
	return false
