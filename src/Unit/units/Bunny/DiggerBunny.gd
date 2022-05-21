extends Bunny

func _init() -> void:
	job = "Excavator"
	special_action = Global.ActionType.DIG
	health = 8
	max_health = 8
	attack = 2
	move_reach = 3
	attack_reach = 1
	special_reach = 1
