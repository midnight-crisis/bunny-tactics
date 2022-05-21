extends Control

signal turn_end

onready var EndTurnButton = $MarginContainer/InfoElements/EndTurnButton
onready var Turn = $MarginContainer/InfoElements/Turn

var turn = Global.Team.PLAYER

func _ready() -> void:
	update()

func update():
	Turn.text = "Turn: " + Global.TeamName[turn]

func _on_EndTurnButton_pressed() -> void:
	emit_signal("turn_end")
	
	if (turn == Global.Team.PLAYER):
		turn = Global.Team.ENEMY
	elif (Global.Team.ENEMY):
		turn = Global.Team.PLAYER
	
	update()
	
