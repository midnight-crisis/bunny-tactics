extends Node2D

signal unit_selected

onready var NormalBunny = preload("res://Unit/units/Bunny/NormalBunny.tscn")

var current_unit = null

func _ready() -> void:
	pass
	
func add_unit(unit_type, x = 0, y = 0):
	var new_unit = NormalBunny.instance();
	add_child(new_unit)
	place_unit(new_unit, x, y)
	new_unit.connect("unit_clicked", self, "_on_unit_selected")

func place_unit(unit: Unit, x, y):
	if (unit):
		var x_pos = floor((x + 0.5) * Global.CELL_WIDTH)
		var y_pos = floor((y + 1) * Global.CELL_HEIGHT) - Global.UNIT_VERTICAL_OFFSET
		
		unit.Tweener.interpolate_property(unit, "position", unit.position, Vector2(x_pos, y_pos), 1, Tween.TRANS_QUINT, Tween.EASE_OUT)
		unit.Tweener.start()
		# unit.set_position(Vector2(x_pos, y_pos))

func _on_unit_selected(unit):
	if (current_unit):
		current_unit.Arrow.visible = false
	
	unit.Arrow.visible = true
	current_unit = unit
	
	emit_signal("unit_selected", unit)
