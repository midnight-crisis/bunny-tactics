extends Enemy

func _init() -> void:
	species = "Snake"
	job = "Slithering"
	special_action = Global.ActionType.NONE

	health = 3
	max_health = 3
	attack = 2
	move_reach = 6
	attack_reach = 1

	can_traverse_holes = false
	can_traverse_water = false
	can_traverse_fence = true
