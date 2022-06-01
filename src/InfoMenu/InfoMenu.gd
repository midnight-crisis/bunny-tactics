extends Control

signal end_turn_button_pressed

onready var Turn = $Container/Content/Turn
onready var Wave = $Container/Content/Wave
onready var EndTurnButton = $Container/Content/EndTurnButton

func _ready() -> void:
	pass
	
# ======================================
# Update
# ======================================

func update_wave(wave: int):
	Wave = "Wave " + String(wave)
	
func update_turn(turn: int, team: int):
	Turn.text = "Turn " + String(turn) + ": " + Global.TeamName[team]
	_update_end_turn_button(team)

func _update_end_turn_button(team: int):
	if (team == Global.Team.PLAYER):
		EndTurnButton.disabled = false
	else:
		EndTurnButton.disabled = true

# ======================================
# EndTurnButton
# ======================================

func _on_EndTurnButton_pressed() -> void:
	emit_signal("end_turn_button_pressed")
