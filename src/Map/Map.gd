extends Node2D

onready var MapData = $MapData
onready var MapGrid = $MapGrid

func _ready() -> void:
	MapData.fill(Global.Tile.GROUND)
	MapData.set_tile(2, 3, 0)
	MapData.set_tile(5, 7, 0)
	MapGrid.render_map_data(MapData)
	pass 
