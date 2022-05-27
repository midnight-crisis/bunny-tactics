extends Node2D
class_name Unit

var first_name: String = "<Name>"
var species: String = "<Species>"
var job: String = "<Job>"

var map_position: Vector2 = Vector2(-1, -1)
var is_hole_traversing: bool = false
var is_water_traversing: bool = false
var is_fence_traversing: bool = false

var max_health: int = 10
var health: int = max_health
var passive_heal: int = 0
var attack: int = 1

var move_reach: int = 3
var attack_reach: int = 1
var special_reach: int = 2
var special_action: int = Global.ActionType.SPECIAL_NONE

var team: int = Global.Team.NONE
var has_moved: bool = false
var has_acted: bool = false

onready var UnitSprite = $UnitSprite
onready var ArrowSprite = $ArrowSprite
onready var InteractArea = $InteractArea

func _ready() -> void:
	pass

# ======================================
# Position
# ======================================

func get_position() -> Vector2:
	return map_position

func set_position(pos: Vector2) -> void:
	map_position = pos

# ======================================
# Health
# ======================================

func get_health() -> int:
	return health

func set_health(n: int) -> void:
	health = int(clamp(n, 0, max_health))
	
func get_max_health() -> int:
	return max_health

func set_max_health(n: int) -> void:
	var health_difference = n - max_health
	if (health_difference > 0):
		heal(health_difference)
	elif(health_difference < 0):
		damage(health_difference)
	
	max_health = int(max(n, 1))

# ======================================
# Damage / Healing
# ======================================

func damage(n: int) -> void:
	set_health(health - n)
	
func damage_percentage(k: float) -> void:
	set_health(health * k)
	
func damage_by_unit(unit: Unit) -> void:
	damage(unit.attack)

func heal(n: int) -> void:
	set_health(health + n)

func heal_percentage(k: float) -> void:
	set_health(health * (k + 1))
	
func passive_heal() -> void:
	set_health(health + passive_heal)
	
# ======================================
# Team
# ======================================

func get_team() -> int:
	return team

func set_team(t: int) -> void:
	team = t

# ======================================
# Flag Options
# ======================================

func flag_movement() -> void:
	has_moved = true

func flag_action() -> void:
	has_acted = true

func reset_flags() -> void:
	has_moved = false
	has_acted = false

# ======================================
# InteractArea
# ======================================

func _on_InteractArea_mouse_entered() -> void:
	ArrowSprite.visble = true

func _on_InteractArea_mouse_exited() -> void:
	ArrowSprite.visble = false
