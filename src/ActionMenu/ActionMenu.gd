extends Control

var unit = null

onready var Title = $MarginContainer/ActionElements/Info/Title
onready var Health = $MarginContainer/ActionElements/Info/Health

func _ready() -> void:
	pass
	
func set_unit(unit_):
	unit = unit_
	set_info()

func set_info():
	if (unit):
		Title.text = unit.fullname + ", " + unit.job + " " + unit.species 
		Health.text = "HP: " + String(unit.health) + "/" + String(unit.max_health)

