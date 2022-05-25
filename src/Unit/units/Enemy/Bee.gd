extends Enemy

func _init() -> void:
	species = "Bee"
	job = "Buzzing"
	special_action = Global.ActionType.NONE

	health = 3
	max_health = 3
	attack = 2
	move_reach = 5
	attack_reach = 2

	can_traverse_holes = true
	can_traverse_water = true
	can_traverse_fence = true
