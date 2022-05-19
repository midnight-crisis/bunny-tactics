extends Node2D
class_name Unit

signal unit_clicked

var fullname = "Unnamed"
var species = "Human"
var job = "Dummy"

var tile_position = Vector2(-1, -1)
var health = 15
var max_health = 30
var attack = 1


onready var Name = $Name
onready var UnitSprite = $Sprite
onready var Arrow = $Arrow
onready var Tweener = $Tweener

func _ready() -> void:
	Name.text = fullname

func _on_InteractArea_mouse_entered() -> void:
	Name.visible = true

func _on_InteractArea_mouse_exited() -> void:
	Name.visible = false

func _on_InteractArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton && event.pressed):
		emit_signal("unit_clicked", self)
