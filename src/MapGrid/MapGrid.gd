extends Node2D

signal selected_square_changed

onready var Square = preload("res://MapGridSquare/MapGridSquare.tscn")

var grid = []
var selected_square_position = Vector2(-1, -1)

func _ready() -> void:
	for x in range(Global.MAP_TILES_WIDTH):
		grid.append([])
		for y in range(Global.MAP_TILES_HEIGHT):
			grid[x].append(null)
	
func generate(w, h):
	for x in range(w):
		for y in range(h):
			var new_square = Square.instance()
			grid[x][y] = new_square
			
			add_child(new_square)
			new_square.for_tile = Vector2(x, y)
			new_square.position = Vector2(x * Global.CELL_WIDTH, y * Global.CELL_HEIGHT)
			new_square.connect("square_clicked", self, "_on_square_selected")

func highlight_tiles(tile_positions):
	dehighlight_all()
	for p in tile_positions:
		if ((p.x < Global.MAP_TILES_WIDTH && p.x >= 0) && (p.y < Global.MAP_TILES_HEIGHT && p.y >= 0)):
			grid[p.x][p.y].highlight()

func highlight(x, y):
	grid[x][y].highlight()

func dehighlight(x, y):
	grid[x][y].dehighlight()

func dehighlight_all():
	for x in range(Global.MAP_TILES_WIDTH):
		for y in range(Global.MAP_TILES_HEIGHT):
			grid[x][y].dehighlight()

func _on_square_selected(pos):
	selected_square_position = pos
	emit_signal("selected_square_changed", pos)
	print(pos)

func _on_reachable_tiles_change(tile_positions):
	highlight_tiles(tile_positions)
