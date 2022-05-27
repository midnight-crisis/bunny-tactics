extends Node2D

# ======================================
# Units
# ======================================

func get_units() -> Array:
	return self.get_children()

# ======================================
# Movement
# ======================================

func move_unit(unit: Unit, grid_position: Vector2) -> void:
	var x = (grid_position.x + 0.5) * Global.CELL_WIDTH
	var y = ((grid_position.y + 0.5) * Global.CELL_HEIGHT) + Global.UNIT_VERTICAL_OFFSET
	unit.position = Vector2(x, y)
