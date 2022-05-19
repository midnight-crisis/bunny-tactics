extends Node2D

onready var Version = $Camera/UI/Version
onready var ActionMenu = $Camera/UI/ActionMenu
onready var GameCamera = $Camera
onready var UnitManager = $UnitManager
onready var Map = $Map

func _ready() -> void:
	UnitManager.connect("unit_selected", ActionMenu, "set_unit")
	UnitManager.connect("unit_selected", GameCamera, "focus_on_unit")
	ActionMenu.connect("action_selected", UnitManager, "_on_action_selected")
	Map.connect("active_tile_changed", self, "_on_active_tile_change")
	
	Version.text = "bunny-tactics v" + Global.VERSION
	UnitManager.add_unit(null, 3, 3)
	UnitManager.add_unit(null, 2, 5)
	UnitManager.add_unit(null, 7, 1)
	UnitManager.add_unit(null, 9, 7)
	pass

func _on_active_tile_change(pos):
	if (UnitManager.current_action == Global.ActionType.MOVE):
		UnitManager.place_unit(UnitManager.current_unit, pos.x, pos.y)
		UnitManager.current_action = Global.ActionType.NONE
		GameCamera.focus_on_tile(pos)
		
	elif (UnitManager.current_action == Global.ActionType.ATTACK):
		var target_unit = UnitManager.find_unit_on_tile(pos)
		if (target_unit):
			target_unit.health -= UnitManager.current_unit.attack
		UnitManager.current_action = Global.ActionType.NONE
		
	ActionMenu.set_info()

