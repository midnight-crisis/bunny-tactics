extends Node2D

onready var DamageNumber = $DamageNumber
onready var Timer = $Timer

func _ready() -> void:
	pass
	
func set_number(n):
	DamageNumber.text = String(n)

func _on_Timer_timeout() -> void:
	self.queue_free()
