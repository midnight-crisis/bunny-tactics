extends Node2D

signal game_over

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
onready var UnitSpawner = $UnitSpawner
onready var UpgradeMenu = $Camera/UI/UpgradeMenu

var turn = Global.Team.PLAYER
var wave = 1

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
	UnitSpawner.connect("units_for_placement", UnitManager, "_on_units_for_placement")
	UpgradeMenu.connect("upgrade_add_unit", self, "_on_upgrade_add_unit")
	UpgradeMenu.connect("upgrade_heal", self, "_on_upgrade_heal")

	Ai.connect("move", self, "_on_AI_move")
	Ai.connect("attack", self, "_on_AI_attack")
	Ai.connect("wait", self, "_on_AI_wait")
	AITurnTimer.connect("timeout", self, "_on_AI_turn_timer")

	Map.fill(Global.Tile.GROUND)
	
	UnitManager.add_unit(Global.UnitType.BUNNY_FLOODER, 0, 1)
	#UnitManager.add_unit(Global.UnitType.BUNNY_HEALER, 1, 2)
	#UnitManager.add_unit(Global.UnitType.BUNNY_DIGGER, 1, 4)
	#UnitManager.add_unit(Global.UnitType.BUNNY_BUILDER, 0, 5)
	#UnitManager.add_unit(Global.UnitType.BUNNY_NORMAL, 2, 3)
	UnitSpawner.spawn_enemies(wave, Map.tiles, UnitManager.units)
	
	turn = Global.Team.PLAYER
	wave = 1
	InfoMenu.set_wave(wave)

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
			UnitManager.current_unit.anim_wait()
	
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
				UnitManager.current_unit.anim_move()
		
	elif (UnitManager.current_action == Global.ActionType.ATTACK):
		var target_unit = UnitManager.units[pos.x][pos.y]
		if (target_unit):
			if (UnitManager.reachable_tiles.has(pos) && !UnitManager.current_unit.has_acted):
				var damage = UnitManager.current_unit.attack
				target_unit.hurt(damage)
				UnitManager.flag_action()
				spawn_damage_particle(target_unit.position + Vector2(0, Global.DAMAGE_PARTICLE_Y_OFFSET), damage)
				UnitManager.current_unit.anim_attack()
	
	elif (UnitManager.current_action == Global.ActionType.HEAL):
		var target_unit = UnitManager.units[pos.x][pos.y]
		if (target_unit):
			if (UnitManager.reachable_tiles.has(pos) && !UnitManager.current_unit.has_acted):
				var heal = UnitManager.current_unit.heal_amount
				target_unit.hurt(-heal)
				UnitManager.flag_action()
				spawn_damage_particle(target_unit.position + Vector2(0, Global.DAMAGE_PARTICLE_Y_OFFSET), -heal)
				UnitManager.current_unit.anim_special()
				
	elif (UnitManager.current_action == Global.ActionType.DIG && (Map.get_tile(pos.x, pos.y) == Global.Tile.GROUND)):
		if (UnitManager.get_unit(pos.x, pos.y) == null && Map.get_tile(pos.x, pos.y) == Global.Tile.GROUND):
			if (UnitManager.reachable_tiles.has(pos) && !UnitManager.current_unit.has_acted):
				Map.set_tile(pos.x, pos.y, Global.Tile.EMPTY)
				UnitManager.flag_action()
				UnitManager.current_unit.anim_special()
	
	elif (UnitManager.current_action == Global.ActionType.FLOOD):
		if (UnitManager.get_unit(pos.x, pos.y) == null && (Map.get_tile(pos.x, pos.y) == Global.Tile.GROUND || Map.get_tile(pos.x, pos.y) == Global.Tile.EMPTY)):
			if (UnitManager.reachable_tiles.has(pos) && !UnitManager.current_unit.has_acted):
				Map.set_tile(pos.x, pos.y, Global.Tile.WATER)
				UnitManager.flag_action()
				UnitManager.current_unit.anim_special()
	
	elif (UnitManager.current_action == Global.ActionType.BUILD && (Map.get_tile(pos.x, pos.y) == Global.Tile.GROUND)):
		if (UnitManager.get_unit(pos.x, pos.y) == null && Map.get_tile(pos.x, pos.y) == Global.Tile.GROUND):
			if (UnitManager.reachable_tiles.has(pos) && !UnitManager.current_unit.has_acted):
				Map.set_tile(pos.x, pos.y, Global.Tile.FENCE)
				UnitManager.flag_action()
				UnitManager.current_unit.anim_special()
		
	UnitManager.current_action = Global.ActionType.NONE
	UnitManager.reset_action()
	ActionMenu.set_info()
	
	if (UnitManager.units[pos.x][pos.y] == null):
		UnitManager.reset_selection()
		ActionMenu.hide()
	
func _check_if_enemies_remain():
	for u in UnitManager.get_children():
		if (u.team == Global.Team.ENEMY):
			return true
	return false
	
func _on_turn_end():		

	for u in UnitManager.get_children():
		u.reset_flags()
	
	if (!_check_if_enemies_remain() && turn == Global.Team.ENEMY):
		wave += 1
		InfoMenu.turn_number = 0
		InfoMenu.set_wave(wave)
		UnitSpawner.spawn_enemies(wave, Map.tiles, UnitManager.units)
		
		var friendly_units = []
		for u in UnitManager.get_children():
			if (u.team == Global.Team.PLAYER):
				friendly_units.append(u)
		UpgradeMenu.upgrade(friendly_units)	
	
	if (turn == Global.Team.ENEMY):
		var friendly_units = []
		for u in UnitManager.get_children():
			if (u.team == Global.Team.PLAYER):
				friendly_units.append(u)
				
		if (friendly_units == []):
			print("Game over!")
			emit_signal("game_over", wave)
			
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
	unit.anim_move()

func _on_AI_attack(unit, target):
	var damage = unit.attack
	target.hurt(damage)
	spawn_damage_particle(target.position + Vector2(0, Global.DAMAGE_PARTICLE_Y_OFFSET), damage)
	unit.anim_attack()

func _on_AI_wait(unit):
	var heal = unit.passive_heal_amount
	unit.hurt(-heal)
	spawn_damage_particle(unit.position + Vector2(0, Global.DAMAGE_PARTICLE_Y_OFFSET), -heal)
	unit.anim_wait()
	
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
	
func _on_upgrade_add_unit():
	var empty_tile = _get_empty_tile_on_left_side()
	UnitManager.add_unit(Global.UnitType.BUNNY_NORMAL, empty_tile.x, empty_tile.y)

func _on_upgrade_heal():
	for u in UnitManager.get_children():
		if (u.team == Global.Team.PLAYER):
			var heal = int(ceil(u.max_health / 2))
			u.hurt(-heal)
			spawn_damage_particle(u.position + Vector2(0, Global.DAMAGE_PARTICLE_Y_OFFSET), -heal)
			
func _get_empty_tile_on_left_side():
	var ok = false
	var pos = Vector2(-1, -1)
	while(!ok):
		pos = _get_random_tile_on_left_side()
		
		if (pos.x < 0 || pos.x > Global.MAP_TILES_WIDTH): ok = false
		elif (pos.y < 0 || pos.y > Global.MAP_TILES_HEIGHT): ok = false
		elif (Map.tiles[pos.x][pos.y] != Global.Tile.GROUND): ok = false
		elif (UnitManager.units[pos.x][pos.y] != null): ok = false
		else: ok = true
		
	return pos

func _get_random_tile_on_left_side():
	var midpoint = int(floor(Global.MAP_TILES_WIDTH / 2))
	return Vector2(Global.rng.randi() % midpoint, Global.rng.randi() % Global.MAP_TILES_HEIGHT)
			
