extends Node2D

func _ready() -> void:
	pass

func place_unit(unit: Unit, x, y):
	var x_pos = floor((x + 0.5) * Global.CELL_WIDTH)
	var y_pos = floor((y + 1) * Global.CELL_HEIGHT) - Global.UNIT_VERTICAL_OFFSET
	unit.set_position(Vector2(x_pos, y_pos))
