extends Enemy

func _init() -> void:
	species = "Mole"
	job = "Tunneling"
	special_action = Global.ActionType.NONE

	health = 7
	max_health = 7
	attack = 2
	move_reach = 3
	attack_reach = 2

	can_traverse_holes = true
	can_traverse_water = false
	can_traverse_fence = false
