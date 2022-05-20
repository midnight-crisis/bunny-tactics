extends Node2D

onready var DamageParticle = preload("res://DamageParticle/DamageParticle.tscn")

onready var Version = $Camera/UI/Version
onready var ActionMenu = $Camera/UI/ActionMenu
onready var GameCamera = $Camera
onready var UnitManager = $UnitManager
onready var Map = $Map
onready var MapGrid = $Map/MapGrid

func _ready() -> void:
	Version.text = "bunny-tactics v" + Global.VERSION
	
	UnitManager.connect("unit_selected", ActionMenu, "set_unit")
	UnitManager.connect("unit_selected", GameCamera, "focus_on_unit")
	UnitManager.connect("reachable_tiles_changed", MapGrid, "_on_reachable_tiles_change")
	ActionMenu.connect("action_selected", UnitManager, "_on_action_selected")
	Map.connect("active_tile_changed", self, "_on_active_tile_change")

	Map.fill(Global.Tile.GROUND)
	UnitManager.add_unit(Global.UnitType.BUNNY_NORMAL, 3, 3)
	UnitManager.add_unit(Global.UnitType.BUNNY_HEALER, 2, 5)
	UnitManager.add_unit(Global.UnitType.BUNNY_BUILDER, 7, 1)
	UnitManager.add_unit(Global.UnitType.BUNNY_DIGGER, 9, 7)
	UnitManager.add_unit(Global.UnitType.BUNNY_FLOODER, 9, 2)

func spawn_damage_particle(pos: Vector2, n):
	var damage_particle = DamageParticle.instance()
	add_child(damage_particle)
	damage_particle.position = pos
	damage_particle.set_number(n)

func _on_active_tile_change(pos):
	if (UnitManager.current_action == Global.ActionType.MOVE):
		if (UnitManager.get_unit(pos.x, pos.y) == null):
			if (UnitManager.reachable_tiles.has(pos)):
				UnitManager.place_unit(UnitManager.current_unit, pos.x, pos.y)
				GameCamera.focus_on_tile(pos)
				UnitManager.current_action = Global.ActionType.NONE
				UnitManager.reset_action()
		
	elif (UnitManager.current_action == Global.ActionType.ATTACK):
		var target_unit = UnitManager.units[pos.x][pos.y]
		if (target_unit):
			if (UnitManager.reachable_tiles.has(pos)):
				target_unit.health -= UnitManager.current_unit.attack
				UnitManager.current_action = Global.ActionType.NONE
				spawn_damage_particle(target_unit.position + Vector2(0, Global.DAMAGE_PARTICLE_Y_OFFSET), UnitManager.current_unit.attack)
				UnitManager.reset_action()
	
		
	ActionMenu.set_info()

