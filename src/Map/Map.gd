extends Node2D

onready var MapData = $MapData
onready var MapGrid = $MapGrid

func _ready() -> void:
	MapData.fill(Global.Tile.GROUND)
	MapGrid.render_map_data(MapData)
	pass 
