extends Control

onready var Logo = $Logo
onready var Credits = $Credits
onready var L2CTimer = $LogoToCreditsTimer
onready var C2NTimer = $CreditstToNextTimer

func _ready() -> void:
	L2CTimer.start()

func _on_LogoToCreditsTimer_timeout() -> void:
	Logo.visible = false
	C2NTimer.start()

func _on_CreditstToNextTimer_timeout() -> void:
	Credits.visible = false
