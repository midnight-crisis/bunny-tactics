extends Unit
class_name Bunny

func _init() -> void:
	player_controllable = true
	fullname = NameGenerator.generate_good_name()
	species = "Bunny"
	job = "Template"
	team = Global.Team.PLAYER
