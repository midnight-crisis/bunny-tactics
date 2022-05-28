extends Node2D

signal grid_position_changed

onready var Square = preload("res://MapGridSquare/MapGridSquare.tscn")

var squares = []

func _ready() -> void:
	Global.init_2d_array(squares, Global.CELL_WIDTH, Global.CELL_HEIGHT)
	for x in range(Global.CELL_WIDTH):
		for y in range(Global.CELL_HEIGHT):
			var square = _create_square(Vector2(x, y))

# ======================================
# Squares
# ======================================

func _create_square(pos: Vector2) -> MapGridSquare:
	var square = Square.instance()
	add_child(square)
	square.set_position(pos)
	square.connect("square_selected", self, "_on_square_selected")
	return square

func _on_square_selected(square: MapGridSquare) -> void:
	emit_signal("grid_position_changed", square.get_position())
