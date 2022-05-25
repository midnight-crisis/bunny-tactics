extends TileMap

func _ready():
	pass

func render(tiles):
	for x in range (tiles.size()):
		for y in range (tiles[0].size()):
			set_cell(x, y, tiles[x][y])
