extends Unit
class_name Enemy

func _init() -> void:
	fullname = NameGenerator.generate_bad_name()
	species = "Enemy"
	job = "Template"
