extends Node2D

onready var Version = $Camera/UI/Version
onready var ActionMenu = $Camera/UI/ActionMenu
onready var UnitManager = $UnitManager
onready var Map = $Map

var current_action = Global.ActionType.NONE

func _ready() -> void:
	UnitManager.connect("unit_selected", ActionMenu, "set_unit")
	ActionMenu.connect("action_selected", self, "_on_action_selected")
	Map.connect("active_tile_changed", self, "_on_active_tile_change")
	
	Version.text = "bunny-tactics v" + Global.VERSION
	UnitManager.add_unit(null, 3, 3)
	UnitManager.add_unit(null, 2, 5)
	UnitManager.add_unit(null, 7, 1)
	UnitManager.add_unit(null, 9, 7)
	pass

func _on_active_tile_change(pos):
	if (current_action == Global.ActionType.MOVE):
		UnitManager.place_unit(UnitManager.current_unit, pos.x, pos.y)
		current_action = Global.ActionType.NONE

func _on_action_selected(action):
	current_action = action
