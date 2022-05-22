extends Node2D

onready var DamageParticle = preload("res://DamageParticle/DamageParticle.tscn")

onready var Version = $Camera/UI/Version
onready var ActionMenu = $Camera/UI/ActionMenu
onready var InfoMenu = $Camera/UI/InfoMenu
onready var TurnPopup = $Camera/UI/TurnPopup
onready var GameCamera = $Camera
onready var UnitManager = $UnitManager
onready var Map = $Map
onready var MapGrid = $Map/MapGrid
onready var Ai = $AI
onready var AITurnTimer = $AITurnTimer

var turn = Global.Team.PLAYER

func _ready() -> void:
	Version.text = "bunny-tactics v" + Global.VERSION
	
	UnitManager.connect("unit_selected", ActionMenu, "set_unit")
	UnitManager.connect("unit_selected", GameCamera, "focus_on_unit")
	UnitManager.connect("reachable_tiles_changed", MapGrid, "_on_reachable_tiles_change")
	UnitManager.connect("move_taken", ActionMenu, "_on_move_taken")
	UnitManager.connect("action_taken", ActionMenu, "_on_action_taken")
	ActionMenu.connect("action_selected", UnitManager, "_on_action_selected")
	UnitManager.connect("non_target_action_selected", self, "_on_non_target_action_selected")
	InfoMenu.connect("turn_end", UnitManager, "_on_turn_end")
	InfoMenu.connect("turn_end", ActionMenu, "_on_turn_end")
	InfoMenu.connect("turn_end", self, "_on_turn_end")
	InfoMenu.connect("next_turn", TurnPopup, "_on_next_turn")
	Map.connect("active_tile_changed", self, "_on_active_tile_change")
	
	
	Ai.connect("move", self, "_on_AI_move")
	Ai.connect("attack", self, "_on_AI_attack")
	Ai.connect("wait", self, "_on_AI_wait")
	AITurnTimer.connect("timeout", self, "_on_AI_turn_timer")

	Map.fill(Global.Tile.GROUND)
	UnitManager.add_unit(Global.UnitType.BUNNY_NORMAL, 3, 3)
	UnitManager.add_unit(Global.UnitType.BUNNY_HEALER, 2, 5)
	UnitManager.add_unit(Global.UnitType.BUNNY_BUILDER, 7, 1)
	UnitManager.add_unit(Global.UnitType.BUNNY_DIGGER, 9, 7)
	UnitManager.add_unit(Global.UnitType.BUNNY_FLOODER, 9, 2)
	UnitManager.add_unit(Global.UnitType.ENEMY_SQUIRREL, 13, 3)
	UnitManager.add_unit(Global.UnitType.ENEMY_BEE, 3, 4)
	UnitManager.add_unit(Global.UnitType.ENEMY_BUTTERFLY, 17, 1)
	UnitManager.add_unit(Global.UnitType.ENEMY_MOLE, 19, 7)
	UnitManager.add_unit(Global.UnitType.ENEMY_SNAKE, 19, 2)
	
	turn = Global.Team.PLAYER

func spawn_damage_particle(pos: Vector2, n):
	var damage_particle = DamageParticle.instance()
	add_child(damage_particle)
	damage_particle.position = pos
	damage_particle.set_number(n)
	
func _on_non_target_action_selected():
	if (UnitManager.current_action == Global.ActionType.WAIT):
		if (!UnitManager.current_unit.has_acted):
			var heal = UnitManager.current_unit.passive_heal_amount
			UnitManager.current_unit.hurt(-heal)
			UnitManager.flag_action()
			spawn_damage_particle(UnitManager.current_unit.position + Vector2(0, Global.DAMAGE_PARTICLE_Y_OFFSET), -heal)
	
	UnitManager.current_action = Global.ActionType.NONE
	UnitManager.reset_action()
	ActionMenu.set_info()

func _on_active_tile_change(pos):
	
	if (UnitManager.current_action == Global.ActionType.MOVE):
		if (UnitManager.get_unit(pos.x, pos.y) == null && Map.get_tile(pos.x, pos.y) == Global.Tile.GROUND):
			if (UnitManager.reachable_tiles.has(pos) && !UnitManager.current_unit.has_moved):
				UnitManager.place_unit(UnitManager.current_unit, pos.x, pos.y)
				UnitManager.flag_move()
				GameCamera.focus_on_tile(pos)
		
	elif (UnitManager.current_action == Global.ActionType.ATTACK):
		var target_unit = UnitManager.units[pos.x][pos.y]
		if (target_unit):
			if (UnitManager.reachable_tiles.has(pos) && !UnitManager.current_unit.has_acted):
				var damage = UnitManager.current_unit.attack
				target_unit.hurt(damage)
				UnitManager.flag_action()
				spawn_damage_particle(target_unit.position + Vector2(0, Global.DAMAGE_PARTICLE_Y_OFFSET), damage)
	
	elif (UnitManager.current_action == Global.ActionType.HEAL):
		var target_unit = UnitManager.units[pos.x][pos.y]
		if (target_unit):
			if (UnitManager.reachable_tiles.has(pos) && !UnitManager.current_unit.has_acted):
				var heal = UnitManager.current_unit.heal_amount
				target_unit.hurt(-heal)
				UnitManager.flag_action()
				spawn_damage_particle(target_unit.position + Vector2(0, Global.DAMAGE_PARTICLE_Y_OFFSET), -heal)
				
	elif (UnitManager.current_action == Global.ActionType.DIG && (Map.get_tile(pos.x, pos.y) == Global.Tile.GROUND)):
		if (UnitManager.get_unit(pos.x, pos.y) == null && Map.get_tile(pos.x, pos.y) == Global.Tile.GROUND):
			if (UnitManager.reachable_tiles.has(pos) && !UnitManager.current_unit.has_acted):
				Map.set_tile(pos.x, pos.y, Global.Tile.EMPTY)
				UnitManager.flag_action()
	
	elif (UnitManager.current_action == Global.ActionType.FLOOD):
		if (UnitManager.get_unit(pos.x, pos.y) == null && (Map.get_tile(pos.x, pos.y) == Global.Tile.GROUND || Map.get_tile(pos.x, pos.y) == Global.Tile.EMPTY)):
			if (UnitManager.reachable_tiles.has(pos) && !UnitManager.current_unit.has_acted):
				Map.set_tile(pos.x, pos.y, Global.Tile.WATER)
				UnitManager.flag_action()
	
	elif (UnitManager.current_action == Global.ActionType.BUILD && (Map.get_tile(pos.x, pos.y) == Global.Tile.GROUND)):
		if (UnitManager.get_unit(pos.x, pos.y) == null && Map.get_tile(pos.x, pos.y) == Global.Tile.GROUND):
			if (UnitManager.reachable_tiles.has(pos) && !UnitManager.current_unit.has_acted):
				Map.set_tile(pos.x, pos.y, Global.Tile.FENCE)
				UnitManager.flag_action()
		
	UnitManager.current_action = Global.ActionType.NONE
	UnitManager.reset_action()
	ActionMenu.set_info()
	
	if (UnitManager.units[pos.x][pos.y] == null):
		UnitManager.reset_selection()
		ActionMenu.hide()
	
func _on_turn_end():
	for u in UnitManager.get_children():
		if (u.team == turn):
			u.reset_flags()
	
	if (turn == Global.Team.PLAYER):
		turn = Global.Team.ENEMY
		ActionMenu.hide_actions() 
	elif (turn == Global.Team.ENEMY):
		turn = Global.Team.PLAYER
		ActionMenu.show_actions()
		
	if (turn == Global.Team.ENEMY):
		var timer_mult = 0
		for u in UnitManager.get_children():
			if (u.team == Global.Team.ENEMY):
				timer_mult += 1
				var timer = Timer.new()
				add_child(timer)
				timer.start(Global.AI_UNIT_TIME * timer_mult)
				timer.connect("timeout", self, "_on_AI_unit_timer", [timer, u, Map.tiles, UnitManager.units])
		AITurnTimer.start(Global.AI_UNIT_TIME * (timer_mult + 1))
		
func _on_AI_turn_timer():
	InfoMenu.simulate_end_turn()
	for u in UnitManager.get_children():
			if (u.team == Global.Team.PLAYER):
					u.simulate_click()

func _on_AI_unit_timer(timer, u, map, units):
	u.simulate_click()
	Ai.control(u, map, units)
	timer.queue_free()

func _on_AI_move(unit, pos):	
	GameCamera.focus_on_tile(pos)
	UnitManager.place_unit(unit, pos.x, pos.y)

func _on_AI_attack(unit, target):
	var damage = unit.attack
	target.hurt(damage)
	spawn_damage_particle(target.position + Vector2(0, Global.DAMAGE_PARTICLE_Y_OFFSET), damage)

func _on_AI_wait(unit):
	var heal = unit.passive_heal_amount
	unit.hurt(-heal)
	spawn_damage_particle(unit.position + Vector2(0, Global.DAMAGE_PARTICLE_Y_OFFSET), -heal)
	
func get_reachable_tiles(unit, pos, reach):
	var tiles = _calcTile(unit, pos, reach)
	
	for i in range(0, tiles.size()):
		for j in range(tiles.size() - 1, i):
			if (tiles[i] == tiles[j]):
				tiles.pop_at(j)
	return tiles

func _calcTile(unit, pos, reach):
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
		if (_vIn(t) && (!UnitManager.units[t.x][t.y] || UnitManager.current_action == Global.ActionType.ATTACK)
		&& (Map.tiles[t.x][t.y] == Global.Tile.GROUND
		|| (Map.tiles[t.x][t.y] == Global.Tile.EMPTY && unit.can_traverse_holes)
		|| (Map.tiles[t.x][t.y] == Global.Tile.WATER && unit.can_traverse_water)
		|| (Map.tiles[t.x][t.y] == Global.Tile.FENCE && unit.can_traverse_fence))):
			reachable.append(t)
			reachable.append_array(_calcTile(unit, t, reach - 1))
	
	return reachable

func _vIn(v):
	if ((v.x >= 0 && v.x < Global.MAP_TILES_WIDTH) &&
		(v.y >= 0 && v.y < Global.MAP_TILES_HEIGHT)): return true
	return false
