extends Unit
class_name Bunny

func _init() -> void:
	fullname = NameGenerator.generate_good_name()
	species = "Bunny"
	job = "Template"
