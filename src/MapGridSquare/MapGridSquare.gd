extends Node2D

signal square_clicked

onready var Square = $Square
onready var HighlightSquare = $HighlightSquare
onready var InteractionArea = $InteractionArea

var for_tile = Vector2(-1, -1)

func _on_InteractionArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if (event is InputEventMouseButton && event.pressed && Input.is_action_pressed("click")):
		emit_signal("square_clicked", for_tile)
		
func highlight():
	HighlightSquare.visible = true
	
func dehighlight():
	HighlightSquare.visible = false

func _on_InteractionArea_mouse_entered() -> void:
	Square.visible = true

func _on_InteractionArea_mouse_exited() -> void:
	Square.visible = false
