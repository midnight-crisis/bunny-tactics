extends Control

signal upgrade_add_unit
signal upgrade_heal

enum Upgrades {
	ATTACK,
	MOVE_REACH,
	ATTACK_REACH,
	MEDIC_HEAL,
	NEW_UNIT,
	HEAL
}

onready var upgrades = [
	Upgrades.ATTACK,
	Upgrades.MOVE_REACH,
	Upgrades.ATTACK_REACH,
	Upgrades.MEDIC_HEAL,
	Upgrades.NEW_UNIT,
	Upgrades.HEAL	
]

onready var UpgradeIcon = {
	Upgrades.ATTACK: preload("res://UpgradeMenu/assets/attack-up.png"),
	Upgrades.MOVE_REACH: preload("res://UpgradeMenu/assets/move-up.png"),
	Upgrades.ATTACK_REACH: preload("res://UpgradeMenu/assets/reach-up.png"),
	Upgrades.MEDIC_HEAL: preload("res://UpgradeMenu/assets/medic-heal-up.png"),
	Upgrades.NEW_UNIT: preload("res://UpgradeMenu/assets/new-normal-bun.png"),
	Upgrades.HEAL: 	preload("res://UpgradeMenu/assets/heal.png")
}

onready var DefaultTheme = preload("res://Theme/DefaultThemeBlackText.tres")

onready var RewardMenu = $Reward
onready var UnitMenu = $Unit
onready var UpgradeSprite1 = $Reward/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/UpgradeButton1/UpgradeSprite1
onready var UpgradeSprite2 = $Reward/CenterContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/UpgradeButton2/UpgradeSprite2
onready var UnitGrid = $Unit/CenterContainer2/PanelContainer/MarginContainer/VBoxContainer/GridContainer

var upgrade_1  = null
var upgrade_2  = null
var upgrade_selected = null
var units = []

func _ready() -> void:
	pass

func upgrade(friendly_units):
	_switch_to_reward_menu()
	units = friendly_units
	
	# Get 2 unique rewards
	upgrade_1 = _get_random_upgrade()
	upgrade_2 = upgrade_1
	while (upgrade_2 == upgrade_1):
		upgrade_2 = _get_random_upgrade()
	
	# Set icons for the upgrade buttons
	UpgradeSprite1.texture = UpgradeIcon[upgrade_1]
	UpgradeSprite2.texture = UpgradeIcon[upgrade_2]
	
func apply_upgrade():
	if (upgrade_selected == Upgrades.NEW_UNIT):
		emit_signal("upgrade_add_unit")
		_close_upgrade_window()
	elif (upgrade_selected == Upgrades.HEAL):
		emit_signal("upgrade_heal")
		_close_upgrade_window()
	else: # The other upgrades are unit-dependent
		unit_selection()

func unit_selection():
	_switch_to_unit_menu()
	_clear_unit_grid()
	
	# Create a button for each (friendly) unit
	for u in units:
		if (u.job == "Doctor" || upgrade_selected != Upgrades.MEDIC_HEAL):
			var unit_name = u.fullname
			var unit_job = u.job
			var button_text = unit_name + ": " + unit_job
			_create_new_button(button_text, u)

func apply_unit_upgrade(unit):
	if (upgrade_selected == Upgrades.ATTACK):
		unit.attack += 1
	elif (upgrade_selected == Upgrades.MOVE_REACH):
		unit.move_reach += 1
	elif (upgrade_selected == Upgrades.ATTACK_REACH):
		unit.attack_reach += 1
	elif (upgrade_selected == Upgrades.MEDIC_HEAL):
		unit.heal_amount = int(floor(unit.heal_amount * 1.333))
	else:
		print("Invalid unit upgrade?")
	
	_close_upgrade_window()
	
	
func _on_unit_chosen(unit):
	apply_unit_upgrade(unit)

func _create_new_button(text, unit):
	var button = Button.new()
	UnitGrid.add_child(button)
	button.theme = DefaultTheme
	button.text = text
	button.connect("pressed", self, "_on_unit_chosen", [unit])

func _close_upgrade_window():
	self.visible = false
	RewardMenu.visible = false
	UnitMenu.visible = false

func _switch_to_reward_menu():
	self.visible = true
	RewardMenu.visible = true
	UnitMenu.visible = false

func _switch_to_unit_menu():
	self.visible = true
	RewardMenu.visible = false
	UnitMenu.visible = true
	
func _get_random_upgrade():
	return upgrades[Global.rng.randi() % upgrades.size()]
	
func _on_upgrade_1_selected():
	upgrade_selected = upgrade_1
	apply_upgrade()

func _on_upgrade_2_selected():
	upgrade_selected = upgrade_2
	apply_upgrade()
	
func _clear_unit_grid():
	for g in UnitGrid.get_children():
		UnitGrid.remove_child(g)
		g.queue_free()
