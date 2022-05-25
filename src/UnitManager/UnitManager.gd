extends Node2D

signal unit_selected
signal reachable_tiles_changed
signal non_target_action_selected
signal move_taken
signal action_taken

onready var NormalBunny = preload("res://Unit/units/Bunny/NormalBunny.tscn")
onready var BuilderBunny = preload("res://Unit/units/Bunny/BuilderBunny.tscn")
onready var DiggerBunny = preload("res://Unit/units/Bunny/DiggerBunny.tscn")
onready var FlooderBunny = preload("res://Unit/units/Bunny/FlooderBunny.tscn")
onready var HealerBunny = preload("res://Unit/units/Bunny/HealerBunny.tscn")
onready var GameManager = get_parent()

var units = []
var current_unit = null
var current_action = Global.ActionType.NONE
var reachable_tiles = []
onready var TileCalcHelper = AI.new() # Ai already can calc reachable tiles so I'm just gonna use that lol

func _init():
	for x in range(Global.MAP_TILES_WIDTH):
		units.append([])
		for y in range(Global.MAP_TILES_HEIGHT):
			units[x].append(null)

func _ready() -> void:
	pass
	
func _spawn_unit(unit_type):
	return Global.UnitScene[unit_type].instance()

func add_unit(unit_type, x = 0, y = 0):
	var new_unit = _spawn_unit(unit_type)
	add_child(new_unit)
	place_unit(new_unit, x, y)
	new_unit.connect("unit_clicked", self, "_on_unit_selected")
	new_unit.connect("unit_dead", self, "_on_unit_dead")

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
	
# Iterative
func calculate_reachable_tiles(pos, reach):
	return GameManager.get_reachable_tiles(current_unit, pos, reach)

func reset_action():
	_on_action_selected(Global.ActionType.NONE)
	
func reset_selection():
	_on_unit_selected(null)
	
func flag_move():
	current_unit.has_moved = true
	emit_signal("move_taken")
	
func flag_action():
	if (current_unit):
		current_unit.has_acted = true
		emit_signal("action_taken")
	
func reset_flags():
	if (current_unit != null):
		current_unit.has_moved = false
		current_unit.has_acted = false

func _on_unit_selected(unit):
	if (current_action != Global.ActionType.NONE && unit.health <= 0): 
		print("Can't select, currently using action.")
		return
	
	if (current_unit): 
		current_unit.Arrow.visible = false
	if (unit):
		unit.Arrow.visible = true

	current_unit = unit
	emit_signal("unit_selected", unit)

func _on_action_selected(action):
	current_action = action
	
	if (current_action == Global.ActionType.MOVE):
		reachable_tiles = calculate_reachable_tiles(current_unit.tile_position, current_unit.move_reach)
	elif (current_action == Global.ActionType.ATTACK):
		reachable_tiles = calculate_reachable_tiles(current_unit.tile_position, current_unit.attack_reach)
	elif (current_action == Global.ActionType.HEAL 
		|| current_action == Global.ActionType.DIG
		|| current_action == Global.ActionType.BUILD
		|| current_action == Global.ActionType.FLOOD):
		reachable_tiles = calculate_reachable_tiles(current_unit.tile_position, current_unit.special_reach)
	elif(current_action == Global.ActionType.WAIT):
		reachable_tiles = []
		emit_signal("non_target_action_selected")
	else:
		reachable_tiles = []
		
	emit_signal("reachable_tiles_changed", reachable_tiles)

func _on_turn_end():
	for u in get_children():
		u.has_moved = false
		u.has_acted = false
	
func _on_units_for_placement(units):
	for u in units:
		add_child(u)
		place_unit(u, u.tile_position.x, u.tile_position.y)
		u.connect("unit_clicked", self, "_on_unit_selected")
		u.connect("unit_dead", self, "_on_unit_dead")
		
func _on_unit_dead(unit):
	units[unit.tile_position.x][unit.tile_position.y] = null
	remove_child(unit)
	unit.queue_free()
