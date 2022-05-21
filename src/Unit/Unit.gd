extends Node2D
class_name Unit

signal unit_clicked

var player_controllable = false

var fullname = "Unnamed"
var species = "Human"
var job = "Dummy"
var team = Global.Team.NONE

var special_action = Global.ActionType.SPECIAL_NONE

var tile_position = Vector2(-1, -1)
var health = 15
var max_health = 30
var attack = 1
var passive_heal_amount = 1

var move_reach = 2
var attack_reach = 1
var special_reach = 1

var has_moved = false
var has_acted = false

onready var Name = $Name
onready var UnitSprite = $Sprite
onready var Arrow = $Arrow
onready var HealthBar = $HealthBar
onready var Tweener = $Tweener
onready var UnitCamera = $Camera
onready var ArrowAnimPlayer = $ArrowAnimPlayer

func _ready() -> void:
	Name.text = fullname
	ArrowAnimPlayer.play("Float")
	
func reset_flags():
	has_moved = false
	has_acted = false
	
func hurt(n):
	health = clamp(health - n, 0, max_health)
	HealthBar.set_percentage(float(health) / float(max_health))

func _on_InteractArea_mouse_entered() -> void:
	Name.visible = true

func _on_InteractArea_mouse_exited() -> void:
	Name.visible = false

func _on_InteractArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton && event.pressed && Input.is_action_pressed("click")):
		emit_signal("unit_clicked", self)
