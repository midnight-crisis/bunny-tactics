extends Control


signal action_selected

onready var Title = $MarginContainer/ActionElements/Info/Title
onready var Health = $MarginContainer/ActionElements/Info/Health
onready var MoveButton = $MarginContainer/ActionElements/VBoxContainer2/Actions/MoveButton

var unit = null


func _ready() -> void:
	pass
	
func set_unit(unit_):
	unit = unit_
	set_info()

func set_info():
	if (unit):
		Title.text = unit.fullname + ", " + unit.job + " " + unit.species 
		Health.text = "HP: " + String(unit.health) + "/" + String(unit.max_health)

func _on_MoveButton_pressed() -> void:
	emit_signal("action_selected", Global.ActionType.MOVE)
