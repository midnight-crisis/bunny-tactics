extends Bunny

func _init() -> void:
	job = "Builder"
	special_action = Global.ActionType.BUILD
	health = 10
	max_health = 10
	attack = 2
	move_reach = 2
	attack_reach = 1
	special_reach = 1
	can_traverse_fence = true
