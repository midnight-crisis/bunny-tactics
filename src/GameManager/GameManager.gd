extends Node2D

onready var Version = $Camera/UI/Version
onready var ActionMenu = $Camera/UI/ActionMenu
onready var UnitManager = $UnitManager
onready var Map = $Map

func _ready() -> void:
	UnitManager.connect("unit_selected", ActionMenu, "set_unit")
	Map.connect("active_tile_changed", self, "_on_active_tile_change")
	
	Version.text = "bunny-tactics v" + Global.VERSION
	UnitManager.add_unit(null, 3, 3)
	UnitManager.add_unit(null, 2, 5)
	UnitManager.add_unit(null, 7, 1)
	UnitManager.add_unit(null, 9, 7)
	pass

func _on_active_tile_change(pos):
	UnitManager.place_unit(UnitManager.current_unit, pos.x, pos.y)
