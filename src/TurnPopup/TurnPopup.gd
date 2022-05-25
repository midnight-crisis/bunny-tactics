extends Control

onready var AnimPlayer = $AnimationPlayer
onready var TurnNumber = $CenterContainer2/VBoxContainer/TurnNumber
onready var Team = $CenterContainer2/VBoxContainer/Team

func _ready() -> void:
	pass
	
func _on_next_turn(turn, team):
	TurnNumber.text = "Turn " + String(turn)
	Team.text = String(team)+ "'s Turn!"
	AnimPlayer.play("Swipe")
