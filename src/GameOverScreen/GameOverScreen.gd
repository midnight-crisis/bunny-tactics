extends Control

onready var CloseButton = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/CloseButton
onready var Wave = $CenterContainer/PanelContainer/MarginContainer/VBoxContainer/Wave

func show_popup(n):
	Wave.text = String(n)
	self.visible = true

func _on_CloseButton_pressed() -> void:
	self.visible = false
