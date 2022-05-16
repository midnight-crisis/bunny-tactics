extends Node2D

onready var Version = $Version


func _ready() -> void:
	Version.text = "bunny-tactics v" + Global.version
