extends Bunny

func _init() -> void:
	job = "Fighter"
	health = 8
	max_health = 8
	attack = 20
	move_reach = 6
	attack_reach = 6
	special_reach = 0

	can_traverse_water = true
	can_traverse_fence = true
