extends Node2D

const bar_length = 16
onready var Bar = $Bar

func set_percentage(n: float):
	Bar.rect_size.x = floor(bar_length * n)
	print(n)
