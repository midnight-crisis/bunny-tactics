extends Node2D

onready var UnitManager = $UnitManager
onready var Map = $Map

onready var UnitScene = preload("res://Unit/units/Bunny/Bunny.tscn")

func _ready() -> void:
	var unit = UnitScene.instance()
	UnitManager.add_child(unit)
	UnitManager.place_unit(unit, 4, 4)
	pass
