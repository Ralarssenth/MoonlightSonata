extends Node

onready var game_manager = get_node("/root/game_manager")
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_title_screen_pressed():
	game_manager.close_scene_on_top()
	game_manager.load_new_scene("title")

func _on_overworld_pressed():
	game_manager.close_scene_on_top()
	game_manager.load_new_scene("overworld")

func _on_cabin0_pressed():
	game_manager.close_scene_on_top()
	game_manager.load_new_scene("cabin0")

func _on_sewer_pressed():
	game_manager.close_scene_on_top()
	game_manager.load_new_scene("sewer")
