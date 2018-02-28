extends Node

onready var game_manager = get_node("/root/game_manager")

func _ready():
	pass

func _on_shortcuts_pressed():
	game_manager.load_scene_on_top("scene_selector")
