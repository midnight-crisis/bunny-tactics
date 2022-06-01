extends Control

signal action_selected

onready var HealIcons = {
	DEFAULT = preload("res://ActionMenu/assets/heal-default.png"),
	HOVER = preload("res://ActionMenu/assets/heal-hover.png"),
	PRESS = preload("res://ActionMenu/assets/heal-press.png"),
	DISABLED = preload("res://ActionMenu/assets/heal-disable.png")
}
onready var BuildIcons = {
	DEFAULT = preload("res://ActionMenu/assets/hammer-default.png"),
	HOVER = preload("res://ActionMenu/assets/hammer-hover.png"),
	PRESS = preload("res://ActionMenu/assets/hammer-press.png"),
	DISABLED = preload("res://ActionMenu/assets/hammer-disable.png")
}
onready var DigIcons = {
	DEFAULT = preload("res://ActionMenu/assets/dig-default.png"),
	HOVER = preload("res://ActionMenu/assets/dig-hover.png"),
	PRESS = preload("res://ActionMenu/assets/dig-press.png"),
	DISABLED = preload("res://ActionMenu/assets/dig-disable.png")
}
onready var FloodIcons = {
	DEFAULT = preload("res://ActionMenu/assets/bucket-default.png"),
	HOVER = preload("res://ActionMenu/assets/bucket-hover.png"),
	PRESS = preload("res://ActionMenu/assets/bucket-press.png"),
	DISABLED = preload("res://ActionMenu/assets/bucket-disable.png")
}

onready var Tweener = $Tweener
onready var Title = $Container/Content/Info/Title
onready var Health = $Container/Content/Info/Health
onready var ActionButtons = $Container/Content/Action/ActionButtons
onready var ActionButton = {
	MOVE = $Container/Content/Action/ActionButtons/MoveButton,
	ATTACK = $Container/Content/Action/ActionButtons/AttackButton,
	WAIT = $Container/Content/Action/ActionButtons/WaitButton,
	SPECIAL = $Container/Content/Action/ActionButtons/SpecialButton
}

var current_unit = null # Recieve signal to change unit
var current_team = null # Recieve signal to change team

func _ready() -> void:
	pass
	
# ======================================
# Hide/Disable 
# ======================================

func show() -> void:
	# TODO: Animation
	self.visible = true

func hide() -> void:
	# TODO: Animation
	self.visible = false

func show_actions() -> void:
	# TODO: Animation
	ActionButtons.visible = true

func hide_actions() -> void:
	# TODO: Animation
	ActionButtons.visible = false

func show_special_button() -> void:
	# TODO: Animation
	ActionButtons.SPECIAL.visible = true

func hide_special_button() -> void:
	# TODO: Animation
	ActionButtons.SPECIAL.visible = false
	
func enable_buttons() -> void:
	ActionButtons.MOVE.disabled = false
	ActionButtons.ATTACK.disabled = false
	ActionButtons.WAIT.disabled = false
	ActionButtons.SPECIAL.disabled = false

func disable_move_buttons() -> void:
	# TODO: Animation
	ActionButtons.MOVE.disabled = true

func disable_act_buttons() -> void:
	# TODO: Animation
	ActionButtons.ATTACK.disabled = true
	ActionButtons.WAIT.disabled = true
	ActionButtons.SPECIAL.disabled = true

# ======================================
# Update
# ======================================

func update_menu(unit: Unit) -> void:
	update_info(unit)
	update_buttons(unit)

func update_info(unit: Unit) -> void:
	Title.text = unit.first_name + " the " + unit.job + " " + unit.species
	Health.text = "HP: " + String(unit.health) + "/" + String(unit.max_health)

func update_buttons(unit: Unit) -> void:
	if (unit.team == Global.Team.PLAYER && current_team == Global.Team.PLAYER):
		show_actions()
		enable_buttons()
		if (unit.has_moved): disable_move_buttons()
		if (unit.has_acted): disable_act_buttons()
		update_special_button(unit)
	else:
		hide_actions()

func update_special_button(unit: Unit) -> void: 
	show_special_button()
	
	match(unit.special_action):
		Global.ActionType.BUILD:
			_update_special_button_textures(BuildIcons)
		Global.ActionType.DIG:
			_update_special_button_textures(DigIcons)
		Global.ActionType.FLOOD:
			_update_special_button_textures(FloodIcons)
		Global.ActionType.HEAL:
			_update_special_button_textures(HealIcons)
		_: 
			hide_special_button()

func _update_special_button_textures(icons) -> void:
	ActionButtons.SPECIAL.texture_normal = icons.DEFAULT
	ActionButtons.SPECIAL.texture_hover = icons.HOVER
	ActionButtons.SPECIAL.texture_pressed = icons.PRESS
	ActionButtons.SPECIAL.texture_disabled = icons.DISABLED

# ======================================
# Team/Unit
# ======================================

func _on_unit_change(unit: Unit) -> void:
	current_unit = unit
	update_menu(unit)

func _on_team_change(team: int) -> void:
	current_team = team
	update_menu(current_unit) # ?

# ======================================
# Action Button Pressed
# ======================================

func _on_action_button_pressed(unit: Unit, action_type: int):
	emit_signal("action_selected", unit, action_type)

func _on_MoveButton_pressed() -> void:
	_on_action_button_pressed(current_unit, Global.ActionType.MOVE)

func _on_AttackButton_pressed() -> void:
	_on_action_button_pressed(current_unit, Global.ActionType.ATTACK)

func _on_WaitButton_pressed() -> void:
	_on_action_button_pressed(current_unit, Global.ActionType.WAIT)

func _on_SpecialButton_pressed() -> void:
	_on_action_button_pressed(current_unit, current_unit.special_action)
