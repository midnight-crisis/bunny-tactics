extends Node

const VERSION = "0.1.0"

const WINDOW_WIDTH = 320
const WINDOW_HEIGHT = 180
const CAMERA_Y_OFFSET = 48
const CELL_WIDTH = 16
const CELL_HEIGHT = 16
const MAP_TILES_WIDTH = 18
const MAP_TILES_HEIGHT = 7
const UNIT_VERTICAL_OFFSET = 4
const DAMAGE_PARTICLE_Y_OFFSET = -20
const AI_UNIT_TIME = 2.5
const AI_MOVE_TIME = 1.0
const AI_ACTION_TIME = 1.0
const SPAWN_ENEMY_BASE_AMOUNT = 5
const UPGRADE_ENEMY_BASE_AMOUNT = 3
const UPGRADE_HEAL_PERCENTAGE = 0.5

var rng = RandomNumberGenerator.new()

enum Team {
	NONE = 0,
	PLAYER = 1,
	ENEMY = 101
}

var TeamName = {
	Team.NONE: "No Valid Team",
	Team.PLAYER: "Bunny Force",
	Team.ENEMY: "Garden Foes"
}

# Ground Altas isn't randomized, Godot Bug
# https://github.com/godotengine/godot/issues/36972
enum Tile {
	INVALID = -1,
	EMPTY = 1,
	GROUND = 0,
	WATER = 2
	FENCE = 3
}

enum ActionType {
	INVALID = -1,
	NONE = 0,
	ATTACK = 1,
	MOVE = 2,
	WAIT = 3,
	SPECIAL_NONE = 10,
	BUILD = 11,
	DIG = 12,
	FLOOD = 13,
	HEAL = 14
}

enum UnitType {
	BUNNY_NORMAL = 101,
	BUNNY_BUILDER = 102,
	BUNNY_DIGGER = 103,
	BUNNY_FLOODER = 104
	BUNNY_HEALER = 105,
	ENEMY_SQUIRREL = 1101,
	ENEMY_BEE = 1201,
	ENEMY_BUTTERFLY = 1301,
	ENEMY_MOLE = 1401,
	ENEMY_SNAKE = 1501
}

var UnitScene = {
	UnitType.BUNNY_NORMAL:  preload("res://Unit/units/Bunny/NormalBunny.tscn"),
	UnitType.BUNNY_BUILDER:  preload("res://Unit/units/Bunny/BuilderBunny.tscn"),
	UnitType.BUNNY_DIGGER:  preload("res://Unit/units/Bunny/DiggerBunny.tscn"),
	UnitType.BUNNY_FLOODER:  preload("res://Unit/units/Bunny/FlooderBunny.tscn"),
	UnitType.BUNNY_HEALER:  preload("res://Unit/units/Bunny/HealerBunny.tscn"),
	UnitType.ENEMY_SQUIRREL:  preload("res://Unit/units/Enemy/Squirrel.tscn"),
	UnitType.ENEMY_BEE:  preload("res://Unit/units/Enemy/Bee.tscn"),
	UnitType.ENEMY_BUTTERFLY:  preload("res://Unit/units/Enemy/Butterfly.tscn"),
	UnitType.ENEMY_MOLE:  preload("res://Unit/units/Enemy/Mole.tscn"),
	UnitType.ENEMY_SNAKE:  preload("res://Unit/units/Enemy/Snake.tscn")
}

var Sfx = {
	"HOVER": preload("res://Audio/assets/Bun Bun Battlefield SFX - BUTTON HOVER 1.mp3"),
	"CLICK": preload("res://Audio/assets/Bun Bun Battlefield SFX - BUTTON PRESS 1.mp3"),
	"ATTACK": preload("res://Audio/assets/Bun Bun Battlefield SFX - ATTACK 1.mp3"),
	"BUILD": preload("res://Audio/assets/Bun Bun Battlefield SFX - BUILD 1.mp3"),
	"DIG": preload("res://Audio/assets/Bun Bun Battlefield SFX - DIG 1.mp3"),
	"FLOOD": preload("res://Audio/assets/Bun Bun Battlefield SFX - FLOOD 1.mp3"),
	"MOVE": preload("res://Audio/assets/Bun Bun Battlefield SFX - FOOTSTEPS 1.mp3"),
	"HEAL": preload("res://Audio/assets/Bun Bun Battlefield SFX - HEAL 1.mp3"),
	"OUCH": preload("res://Audio/assets/Bun Bun Battlefield SFX - OUCH 1.mp3"),
	"DEATH": preload("res://Audio/assets/Bun Bun Battlefield SFX - DEATH WOOSH 1.mp3"),
	"ENDTURN": preload("res://Audio/assets/Bun_Bun_Battlefield_SFX_-_END_TURN_1.mp3")
}

func _ready() -> void:
	rng.randomize()
	
func PlayAudio(audio_key):
	var audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = Sfx[audio_key]
	audio_player.volume_db = -11.0
	audio_player.connect("finished", self, "_on_audio_player_end", [audio_player])
	audio_player.play()
	
func _on_audio_player_end(audio_player):
	print("audio player finished")
	audio_player.stop()
	audio_player.queue_free()
