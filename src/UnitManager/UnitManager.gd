extends Node2D

signal unit_selected

onready var NormalBunny = preload("res://Unit/units/Bunny/NormalBunny.tscn")

var units = []
var current_unit = null
var current_action = Global.ActionType.NONE

func _init():
	for x in range(Global.MAP_TILES_WIDTH):
		units.append([])
		for y in range(Global.MAP_TILES_HEIGHT):
			units[x].append(null)

func _ready() -> void:
	pass
	
func add_unit(unit_type, x = 0, y = 0):
	var new_unit = NormalBunny.instance();
	add_child(new_unit)
	place_unit(new_unit, x, y)
	new_unit.connect("unit_clicked", self, "_on_unit_selected")

func place_unit(unit: Unit, x, y):
	if (unit):
		var x_pos = floor((x + 0.5) * Global.CELL_WIDTH)
		var y_pos = floor((y + 1) * Global.CELL_HEIGHT) - Global.UNIT_VERTICAL_OFFSET
		var pos = Vector2(x_pos, y_pos)
		
		units[unit.tile_position.x][unit.tile_position.y] = null
		units[x][y] = unit
		
		unit.tile_position = Vector2(x, y)
		unit.Tweener.interpolate_property(unit, "position", unit.position, pos, 1, Tween.TRANS_QUINT, Tween.EASE_OUT)
		unit.Tweener.start()
		# unit.set_position(Vector2(x_pos, y_pos))
		
func find_unit_on_tile(pos):
	for u in get_children():
		print(String(u.tile_position) + " ? " + String(pos))
		if (pos == u.tile_position):
			return u
	return null
	
func get_unit(x, y):
	return units[x][y]

func _on_unit_selected(unit):
	if (current_action != Global.ActionType.NONE): 
		print("Can't select, currently using action.")
		return
		
	if (current_unit):
		current_unit.Arrow.visible = false
	
	unit.Arrow.visible = true
	current_unit = unit
	
	emit_signal("unit_selected", unit)

func _on_action_selected(action):
	current_action = action


