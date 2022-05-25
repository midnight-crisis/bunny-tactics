extends Enemy

func _init() -> void:
	species = "Butterfly"
	job = "Flying"
	special_action = Global.ActionType.NONE

	health = 3
	max_health = 3
	attack = 1
	move_reach = 9
	attack_reach = 1

	can_traverse_holes = true
	can_traverse_water = true
	can_traverse_fence = true
