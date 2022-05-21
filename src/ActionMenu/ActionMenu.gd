extends Control

signal action_selected

onready var HealIcon = preload("res://ActionMenu/assets/heal-icon.png")
onready var BuildIcon = preload("res://ActionMenu/assets/hammer-icon.png")
onready var DigIcon = preload("res://ActionMenu/assets/dig-icon.png")
onready var FloodIcon = preload("res://ActionMenu/assets/water-icon.png")

onready var Title = $MarginContainer/ActionElements/Info/Title
onready var Health = $MarginContainer/ActionElements/Info/Health
onready var ActionElements = $MarginContainer/ActionElements
onready var AttackButton = $MarginContainer/ActionElements/VBoxContainer2/Actions/AttackButton
onready var MoveButton = $MarginContainer/ActionElements/VBoxContainer2/Actions/MoveButton
onready var WaitButton = $MarginContainer/ActionElements/VBoxContainer2/Actions/WaitButton
onready var SpecialButton = $MarginContainer/ActionElements/VBoxContainer2/Actions/SpecialButton
onready var ActionsContainer = $MarginContainer/ActionElements/VBoxContainer2
onready var Actions = $MarginContainer/ActionElements/VBoxContainer2/Actions
onready var Tweener = $Tweener

var unit = null

func _ready() -> void:
	pass
	
func show():
	Tweener.interpolate_property(self, "rect_position", Vector2(0,32), Vector2(0,0), 1, Tween.TRANS_QUINT, Tween.EASE_OUT)
	Tweener.start()
	print("showing action bar")
	
func hide():
	unit = null
	Tweener.interpolate_property(self, "rect_position", rect_position, Vector2(0,32), 1, Tween.TRANS_QUINT, Tween.EASE_OUT)
	Tweener.start()
	print("HIDING action bar")
	
func set_unit(unit_):
	unit = unit_
	set_info()
	set_special_button()
	set_button_disables()

func set_info():
	if (unit):
		show()
		Title.text = unit.fullname + " the " + unit.job + " " + unit.species 
		Health.text = "HP: " + String(unit.health) + "/" + String(unit.max_health)
		
		if (unit.player_controllable):
			ActionsContainer.visible = true
		else:
			ActionsContainer.visible = false
		
func set_special_button():
	
	if (unit): 	
		SpecialButton.visible = true
		if (unit.special_action == Global.ActionType.HEAL):
			SpecialButton.texture_normal = HealIcon
		elif (unit.special_action == Global.ActionType.BUILD):
			SpecialButton.texture_normal = BuildIcon
		elif (unit.special_action == Global.ActionType.DIG):
			SpecialButton.texture_normal = DigIcon
		elif (unit.special_action == Global.ActionType.FLOOD):
			SpecialButton.texture_normal = FloodIcon
		else:
			SpecialButton.visible = false
	else:
		return
		
func set_button_disables():
	MoveButton.disabled = false
	AttackButton.disabled = false
	MoveButton.disabled = false
	SpecialButton.disabled = false
	
	if (unit):
		if (unit.has_moved):
			MoveButton.disabled = true
		if (unit.has_acted):
			AttackButton.disabled = true
			MoveButton.disabled = true
			SpecialButton.disabled = true
		
func _on_move_taken():
	MoveButton.disabled = true

func _on_action_taken():
	AttackButton.disabled = true
	MoveButton.disabled = true
	SpecialButton.disabled = true
	
func _on_turn_end():
	MoveButton.disabled = false
	AttackButton.disabled = false
	MoveButton.disabled = false
	SpecialButton.disabled = false
	
func hide_actions():
	Actions.visible = false
	
func show_actions():
	Actions.visible = true

func _on_AttackButton_pressed() -> void:
	emit_signal("action_selected", Global.ActionType.ATTACK)
	print("Attacking")

func _on_MoveButton_pressed() -> void:
	emit_signal("action_selected", Global.ActionType.MOVE)
	print("Moving")

func _on_WaitButton_pressed() -> void:
	emit_signal("action_selected", Global.ActionType.WAIT)
	print("Waiting")

func _on_SpecialButton_pressed() -> void:
	emit_signal("action_selected", unit.special_action)
	print("Using Special")

func _on_AttackButton_mouse_entered() -> void:
	Global.PlayAudio("HOVER")

func _on_MoveButton_mouse_entered() -> void:
	Global.PlayAudio("HOVER")

func _on_WaitButton_mouse_entered() -> void:
	Global.PlayAudio("HOVER")

func _on_SpecialButton_mouse_entered() -> void:
	Global.PlayAudio("HOVER")

