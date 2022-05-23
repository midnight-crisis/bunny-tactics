extends Node

onready var GameScreenScene = preload("res://GameManager/GameManager.tscn")

onready var TitleScreen = $TitleScreen
onready var GameOverScreen = $GameOverScreen
var current_screen = null
var game_screen = null
	
func _ready() -> void:
	TitleScreen.connect("start_button_pressed", self, "game_start")
	current_screen = $TitleScreen

func game_start():
	game_screen = GameScreenScene.instance()
	add_child(game_screen)
	TitleScreen.visible = false
	game_screen.connect("game_over", self, "_on_game_over")

func _on_game_over(wave_number):
	TitleScreen.visible = true
	GameOverScreen.show_popup(wave_number)
	remove_child(game_screen)
	game_screen.queue_free()
