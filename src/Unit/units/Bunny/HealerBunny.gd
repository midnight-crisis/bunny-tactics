extends Bunny

var heal_amount = 3

func _init() -> void:
	job = "Doctor"
	special_action = Global.ActionType.HEAL
	health = 8
	max_health = 8
	attack = 1
	move_reach = 3
	attack_reach = 1
	special_reach = 1
