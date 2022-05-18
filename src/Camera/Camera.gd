extends Camera2D

var fixed_point = Vector2(0,0)

func _process(delta):
	var reference_point = get_viewport().get_mouse_position()
	
	if Input.is_action_just_pressed("pan"):
		fixed_point = reference_point
		
	if Input.is_action_pressed("pan"):
		global_position.x -= reference_point.x - fixed_point.x
		global_position.y -= reference_point.y - fixed_point.y
		fixed_point = reference_point

