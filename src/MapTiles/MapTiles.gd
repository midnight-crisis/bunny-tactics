extends TileMap

func _ready():
	pass

func render_map_data(map_data):
	for x in range (map_data.tiles_width):
		for y in range (map_data.tiles_height):
			set_cell(x, y, map_data.tiles[x][y])
