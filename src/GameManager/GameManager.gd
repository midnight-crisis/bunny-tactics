extends Node2D

onready var DamageParticle = preload("res://DamageParticle/DamageParticle.tscn")

onready var Version = $Camera/UI/Version
onready var ActionMenu = $Camera/UI/ActionMenu
onready var GameCamera = $Camera
onready var UnitManager = $UnitManager
onready var Map = $Map
onready var MapGrid = $Map/MapGrid

var turn = Global.Team.NONE

func _ready() -> void:
	Version.text = "bunny-tactics v" + Global.VERSION
	
	UnitManager.connect("unit_selected", ActionMenu, "set_unit")
	UnitManager.connect("unit_selected", GameCamera, "focus_on_unit")
	UnitManager.connect("reachable_tiles_changed", MapGrid, "_on_reachable_tiles_change")
	UnitManager.connect("move_taken", ActionMenu, "_on_move_taken")
	UnitManager.connect("action_taken", ActionMenu, "_on_action_taken")
	ActionMenu.connect("action_selected", UnitManager, "_on_action_selected")
	
	Map.connect("active_tile_changed", self, "_on_active_tile_change")

	Map.fill(Global.Tile.GROUND)
	UnitManager.add_unit(Global.UnitType.BUNNY_NORMAL, 3, 3)
	UnitManager.add_unit(Global.UnitType.BUNNY_HEALER, 2, 5)
	UnitManager.add_unit(Global.UnitType.BUNNY_BUILDER, 7, 1)
	UnitManager.add_unit(Global.UnitType.BUNNY_DIGGER, 9, 7)
	UnitManager.add_unit(Global.UnitType.BUNNY_FLOODER, 9, 2)
	UnitManager.add_unit(Global.UnitType.ENEMY_SQUIRREL, 13, 3)
	UnitManager.add_unit(Global.UnitType.ENEMY_BEE, 12, 5)
	UnitManager.add_unit(Global.UnitType.ENEMY_BUTTERFLY, 17, 1)
	UnitManager.add_unit(Global.UnitType.ENEMY_MOLE, 19, 7)
	UnitManager.add_unit(Global.UnitType.ENEMY_SNAKE, 19, 2)

func spawn_damage_particle(pos: Vector2, n):
	var damage_particle = DamageParticle.instance()
	add_child(damage_particle)
	damage_particle.position = pos
	damage_particle.set_number(n)

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
				target_unit.health -= UnitManager.current_unit.attack
				UnitManager.current_action = Global.ActionType.NONE
				UnitManager.flag_action()
				spawn_damage_particle(target_unit.position + Vector2(0, Global.DAMAGE_PARTICLE_Y_OFFSET), UnitManager.current_unit.attack)
	
	elif (UnitManager.current_action == Global.ActionType.HEAL):
		var target_unit = UnitManager.units[pos.x][pos.y]
		if (target_unit):
			if (UnitManager.reachable_tiles.has(pos) && !UnitManager.current_unit.has_acted):
				var heal = UnitManager.current_unit.attack * 2
				target_unit.health = min(target_unit.health + heal, target_unit.max_health) 
				UnitManager.flag_action()
				spawn_damage_particle(target_unit.position + Vector2(0, Global.DAMAGE_PARTICLE_Y_OFFSET), -heal)
				
	elif (UnitManager.current_action == Global.ActionType.DIG):
		if (UnitManager.get_unit(pos.x, pos.y) == null):
			if (UnitManager.reachable_tiles.has(pos) && !UnitManager.current_unit.has_acted):
				Map.set_tile(pos.x, pos.y, Global.Tile.EMPTY)
				UnitManager.flag_action()
	
	elif (UnitManager.current_action == Global.ActionType.FLOOD):
		if (UnitManager.get_unit(pos.x, pos.y) == null):
			if (UnitManager.reachable_tiles.has(pos) && !UnitManager.current_unit.has_acted):
				Map.set_tile(pos.x, pos.y, Global.Tile.WATER)
				UnitManager.flag_action()
		
	UnitManager.current_action = Global.ActionType.NONE
	UnitManager.reset_action()	
	ActionMenu.set_info()
	
	if (UnitManager.units[pos.x][pos.y] == null):
		print("hidde")
		UnitManager.reset_selection()
		ActionMenu.hide()
	

