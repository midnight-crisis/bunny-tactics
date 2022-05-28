extends Node2D
class_name MapGridSquare

signal square_selected 

onready var HighlightSquare = $HighlightSquare
onready var MovementSquare = $MovementSquare
onready var AttackSquare = $AttackSquare
onready var SpecialSquare = $SpecialSquare
onready var InteractArea = $InteractArea

var grid_position = Vector2(-1, -1)

func _ready() -> void:
	pass
	
func init(pos: Vector2):
	set_position(pos)
	
# ======================================
# Position
# ======================================

func get_position() -> Vector2:
	return grid_position

func set_position(pos: Vector2) -> void:
	grid_position = pos
	
# ======================================
# Squares
# ======================================

func show_highlight_square() -> void:
	HighlightSquare.visible = true

func hide_highlight_square() -> void:
	HighlightSquare.visible = false

func show_square(square_type: int) -> void:
	hide_squares()
	
	match(square_type):
		Global.SquareHighlight.MOVE:
			MovementSquare.visible = true
		Global.SquareHighlight.ATTACK:
			AttackSquare.visible = true
		Global.SquareHighlight.SPECIAL:
			SpecialSquare.visible = true
	
func hide_squares():
	MovementSquare.visible = false
	AttackSquare.visible = false
	SpecialSquare.visible = false
	
# ======================================
# InteractArea
# ======================================

func _on_InteractArea_mouse_entered() -> void:
	show_highlight_square()

func _on_InteractArea_mouse_exited() -> void:
	hide_highlight_square()

func _on_InteractArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (InputEventMouseButton && event.pressed):
		emit_signal("square_selected", self)
