extends Bunny

func _init() -> void:
	job = "Watergunner"
	special_action = Global.ActionType.FLOOD
	health = 1
	max_health = 8
	attack = 1
	move_reach = 3
	attack_reach = 3
	special_reach = 2
