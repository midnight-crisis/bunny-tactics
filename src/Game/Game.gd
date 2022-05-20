extends Node

onready var GameScreenScene = preload("res://GameManager/GameManager.tscn")

onready var TitleScreen = $TitleScreen
var current_screen = null
	
func _ready() -> void:
	TitleScreen.connect("start_button_pressed", self, "game_start")
	current_screen = $TitleScreen

func game_start():
	var game_screen = GameScreenScene.instance()
	add_child(game_screen)
	TitleScreen.visible = false
