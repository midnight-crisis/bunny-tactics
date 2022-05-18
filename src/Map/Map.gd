extends Node2D

onready var MapData = $MapData
onready var MapTiles = $MapTiles

func _ready() -> void:
	MapData.fill(Global.Tile.GROUND)
	MapTiles.render_map_data(MapData)
	pass 
