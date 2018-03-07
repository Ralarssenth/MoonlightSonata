extends Node

onready var game_manager = get_node("/root/game_manager")
onready var player = get_node("player")

var screensize

func _ready():
	set_process(true)

func _process(delta):
	pass

func _on_door_area_entered( area ):
	game_manager.load_new_scene("overworld")
	game_manager.set_player_location("cabin0_door", Vector2(0, 75))