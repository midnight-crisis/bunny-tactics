extends Node

signal units_for_placement

onready var EnemyScene = {
	Global.UnitType.ENEMY_SQUIRREL: preload("res://Unit/units/Enemy/Squirrel.tscn"),
	Global.UnitType.ENEMY_SNAKE: preload("res://Unit/units/Enemy/Snake.tscn"),
	Global.UnitType.ENEMY_MOLE: preload("res://Unit/units/Enemy/Mole.tscn"),
	Global.UnitType.ENEMY_BUTTERFLY: preload("res://Unit/units/Enemy/Butterfly.tscn"),
	Global.UnitType.ENEMY_BEE: preload("res://Unit/units/Enemy/Bee.tscn")	
}

var enemy_types = [
	Global.UnitType.ENEMY_SQUIRREL,
	Global.UnitType.ENEMY_SNAKE,
	Global.UnitType.ENEMY_MOLE,
	Global.UnitType.ENEMY_BUTTERFLY,
	Global.UnitType.ENEMY_BEE
]

var enemy_upgrade_types = [
	"MAX_HEALTH",
	"ATTACK",
	"MOVE_REACH",
	"PASSIVE_HEAL"
]

enum Side {
	EITHER,
	LEFT,
	RIGHT
}

func spawn_enemies(wave, map, units):
	var enemies = []
	var amount = _get_enemy_amount(wave)
	
	for i in range(amount):
		var enemy_type = _get_random_enemy_type()
		var enemy = _get_enemy_instance(enemy_type)
		var upgrade_amount = _get_upgrade_amount(wave)
		_upgrade_enemy(enemy, upgrade_amount)
		enemies.append(enemy)
		_position_unit(enemy, map, units, Side.RIGHT)
		
	emit_signal("units_for_placement", enemies)

func _get_enemy_amount(wave):
	var base = Global.SPAWN_ENEMY_BASE_AMOUNT
	var amount = floor(base + (wave * 0.2))
	return amount

func _get_random_enemy_type():
	return enemy_types[Global.rng.randi() % enemy_types.size()]
	
func _get_enemy_instance(type):
	return EnemyScene[type].instance()

func _get_upgrade_amount(wave):
	var base = Global.UPGRADE_ENEMY_BASE_AMOUNT
	var amount = floor(base + (wave * 0.1))
	return amount

func _get_random_enemy_upgrade():
	return enemy_upgrade_types[Global.rng.randi() % enemy_upgrade_types.size()]

func _upgrade_enemy(enemy, upgrade_amount):
	for i in range(upgrade_amount):
		var upgrade_type = _get_random_enemy_upgrade()
		if (upgrade_type == "MAX_HEALTH"):
			enemy.max_health = floor(enemy.max_health * 1.2)
		elif (upgrade_type == "ATTACK"):
			enemy.attack = enemy.attack + 1
		elif (upgrade_type == "MOVE_REACH"):
			enemy.move_reach = enemy.move_reach + 1
		elif (upgrade_type == "PASSIVE_HEAL"):
			enemy.passive_heal_amount = enemy.passive_heal_amount + 1
		else:
			print("Invalid upgrade type?")
			
func _position_unit(unit, map, units, side = Side.EITHER):
	unit.tile_position = _get_empty_tile(map, units, side)

func _get_empty_tile(map, units, side = Side.EITHER):
	var ok = false
	var pos = Vector2(-1, -1)
	while(!ok):
		
		if (side == Side.RIGHT):
			pos = _get_random_tile_on_right_side()
		else:
			pos = _get_random_tile()
		
		if (pos.x < 0 || pos.x > Global.MAP_TILES_WIDTH): ok = false
		elif (pos.y < 0 || pos.y > Global.MAP_TILES_HEIGHT): ok = false
		elif (map[pos.x][pos.y] != Global.Tile.GROUND): ok = false
		elif (units[pos.x][pos.y] != null): ok = false
		else: ok = true
		
	return pos

func _get_random_tile():
	return Vector2(Global.rng.randi() % Global.MAP_TILES_WIDTH, Global.rng.randi() % Global.MAP_TILES_HEIGHT)

func _get_random_tile_on_right_side():
	var midpoint = int(ceil(Global.MAP_TILES_WIDTH / 2))
	var x_begin = midpoint
	var x_end = Global.MAP_TILES_WIDTH
	var x = midpoint + (Global.rng.randi() % midpoint)
	return Vector2(x, Global.rng.randi() % Global.MAP_TILES_HEIGHT)
