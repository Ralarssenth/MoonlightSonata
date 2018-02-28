extends Node

onready var game_manager = get_node("/root/game_manager")

func _ready():
	pass

func _on_title_screen_pressed():
	game_manager.close_all_scenes_on_top()
	game_manager.load_new_scene("title")

func _on_overworld_pressed():
	game_manager.close_all_scenes_on_top()
	game_manager.load_new_scene("overworld")

func _on_cabin0_pressed():
	game_manager.close_all_scenes_on_top()
	game_manager.load_new_scene("cabin0")

func _on_sewer_pressed():
	game_manager.close_all_scenes_on_top()
	game_manager.load_new_scene("sewer")
