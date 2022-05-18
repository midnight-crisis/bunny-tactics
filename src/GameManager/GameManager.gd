extends Node2D

onready var Version = $Camera/UI/Version
onready var UnitManager = $UnitManager
onready var Map = $Map

onready var UnitScene = preload("res://Unit/units/Bunny/NormalBunny.tscn")

func _ready() -> void:
	Version.text = "bunny-tactics v" + Global.VERSION
	
	var unit = UnitScene.instance()
	UnitManager.add_child(unit)
	UnitManager.place_unit(unit, 4, 4)
	pass
