extends Camera2D

onready var Tweener = $Tweener

var fixed_point = Vector2(0,0)

func _process(delta):
	var reference_point = get_viewport().get_mouse_position()
	
	if Input.is_action_just_pressed("pan"):
		fixed_point = reference_point
		Tweener.stop_all()
		
	if Input.is_action_pressed("pan"):
		global_position.x -= reference_point.x - fixed_point.x
		global_position.y -= reference_point.y - fixed_point.y
		fixed_point = reference_point

func focus_on(x, y):
	var new_x =  x - (Global.WINDOW_WIDTH / 2)
	var new_y =  y - (Global.WINDOW_HEIGHT / 2) 
	Tweener.interpolate_property(self, "position", global_position, Vector2(new_x, new_y), 1, Tween.TRANS_QUINT, Tween.EASE_OUT)
	Tweener.start()
	
func focus_on_unit(unit):
	if (unit):
		pass #focus_on(unit.global_position.x, unit.global_position.y)

func focus_on_tile(tile_position):
	focus_on(tile_position.x * Global.CELL_WIDTH, tile_position.y * Global.CELL_HEIGHT)
