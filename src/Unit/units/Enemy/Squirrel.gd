extends Enemy

func _init() -> void:
	species = "Squirrel"
	job = "Scavenging"
	special_action = Global.ActionType.NONE

	health = 5
	max_health = 5
	attack = 1
	move_reach = 4
	attack_reach = 1

	can_traverse_holes = false
	can_traverse_water = false
	can_traverse_fence = false
