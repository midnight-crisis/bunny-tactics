extends Node2D

signal selected_square_changed

onready var Square = preload("res://MapGridSquare/MapGridSquare.tscn")

var selected_square_position = Vector2(-1, -1)

func _ready() -> void:
	pass
	
func generate(w, h):
	for x in range(w):
		for y in range(h):
			var new_square = Square.instance()
			add_child(new_square)
			new_square.for_tile = Vector2(x, y)
			new_square.position = Vector2(x * Global.CELL_WIDTH, y * Global.CELL_HEIGHT)
			new_square.connect("square_clicked", self, "_on_square_selected")
			

func _on_square_selected(pos):
	selected_square_position = pos
	emit_signal("selected_square_changed", pos)
	print(pos)
