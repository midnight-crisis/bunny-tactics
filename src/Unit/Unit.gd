extends Node2D
class_name Unit

var fullname = "Unnamed"
var species = "Human"
var job = "Dummy"
var health = 0
var speed = 1

onready var Name = $Name
onready var UnitSprite = $Sprite

func _ready() -> void:
	Name.text = fullname


func _on_HoverArea_mouse_entered() -> void:
	Name.visible = true

func _on_HoverArea_mouse_exited() -> void:
	Name.visible = false
