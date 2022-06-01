extends Control

signal turn_end
signal next_turn

onready var EndTurnButton = $MarginContainer/InfoElements/EndTurnButton
onready var Turn = $MarginContainer/InfoElements/Turn
onready var Wave = $MarginContainer/InfoElements/Wave

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
		EndTurnButton.disabled = true
	elif (Global.Team.ENEMY):
		turn = Global.Team.PLAYER
		EndTurnButton.disabled = false
	
	Global.PlayAudio("ENDTURN")
	
	update()
	emit_signal("next_turn", turn_number, Global.TeamName[turn])
	
func simulate_end_turn():
	_on_EndTurnButton_pressed()
	
func set_wave(n):
	Wave.text = "Wave " + String(n)
