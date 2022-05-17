extends Node2D

onready var Version = $Version

func _ready():
	Version.text = "bunny-tactics v" + Global.VERSION
	
