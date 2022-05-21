extends Control

signal turn_end
signal next_turn

onready var EndTurnButton = $MarginContainer/InfoElements/EndTurnButton
onready var Turn = $MarginContainer/InfoElements/Turn

var turn = Global.Team.PLAYER
var turn_number = 1

func _ready() -> void:
	update()

func update():
	Turn.text = "Turn " + String(turn_number) + ": " + Global.TeamName[turn]

func _on_EndTurnButton_pressed() -> void:
	emit_signal("turn_end")
	turn_number += 1
	
	if (turn == Global.Team.PLAYER):
		turn = Global.Team.ENEMY
	elif (Global.Team.ENEMY):
		turn = Global.Team.PLAYER
	
	update()
	emit_signal("next_turn", turn_number, Global.TeamName[turn])
	