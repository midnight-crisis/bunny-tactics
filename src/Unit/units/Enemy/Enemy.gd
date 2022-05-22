extends Unit
class_name Enemy

func _init() -> void:
	player_controllable = false
	fullname = NameGenerator.generate_bad_name()
	species = "Enemy"
	job = "Template"
	team = Global.Team.ENEMY
	move_reach = 3
