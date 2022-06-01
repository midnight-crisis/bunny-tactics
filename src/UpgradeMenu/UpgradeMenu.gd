extends Control

enum Reward {
	ATTACK,
	MOVE_REACH,
	ATTACK_REACH,
	MEDIC_HEAL,
	NEW_UNIT,
	HEAL
}

onready var rewards = [
	Reward.ATTACK,
	Reward.MOVE_REACH,
	Reward.ATTACK_REACH,
	Reward.MEDIC_HEAL,
	Reward.NEW_UNIT,
	Reward.HEAL	
]

onready var RewardIcon = {
	Reward.ATTACK: preload("res://UpgradeMenu/assets/attack-up.png"),
	Reward.MOVE_REACH: preload("res://UpgradeMenu/assets/move-up.png"),
	Reward.ATTACK_REACH: preload("res://UpgradeMenu/assets/reach-up.png"),
	Reward.MEDIC_HEAL: preload("res://UpgradeMenu/assets/medic-heal-up.png"),
	Reward.NEW_UNIT: preload("res://UpgradeMenu/assets/new-normal-bun.png"),
	Reward.HEAL: preload("res://UpgradeMenu/assets/heal.png")
}

onready var RewardDescription = {
	Reward.ATTACK: "Ouch! Increase the attack of a bunny by 50%.",
	Reward.MOVE_REACH: "Nyoom! Increase the movement range of any bunny by 1 tile.",
	Reward.ATTACK_REACH: "Woah! Increase the attack range of any bunny by 1 tile.",
	Reward.MEDIC_HEAL: "Ding! Increase the doctor bunny's heal by 75%.",
	Reward.NEW_UNIT: "Ta-da! Add a new fighter bunny to your team.",
	Reward.HEAL: "Phew! Heal all of your bunnies for up to 50% of their max health."
}

onready var RewardSelection = $RewardSelection
onready var Rewards = $RewardSelection/Center/Panel/Container/Content/Rewards
onready var RewardButtons = [
	$RewardSelection/Center/Panel/Container/Content/Rewards/Reward1Button,
	$RewardSelection/Center/Panel/Container/Content/Rewards/Reward2Button]
onready var RewardIcons = [
	$RewardSelection/Center/Panel/Container/Content/Rewards/Reward1Button/Reward1Icon,
	$RewardSelection/Center/Panel/Container/Content/Rewards/Reward2Button/Reward2Icon]
onready var Description = $RewardSelection/Center/Panel/Container/Content/Description

onready var UnitSelection = $UnitSelection
onready var UnitList = $UnitSelection/Center/Panel/Container/Content/UnitList

func _ready() -> void:
	pass
	
# ======================================
# Reward Selection
# ======================================
