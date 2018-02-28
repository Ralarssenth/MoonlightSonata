extends Node

onready var game_manager = get_node("/root/game_manager")

func _ready():
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#func _on_shortcuts_pressed():
	#game_manager.load_scene_on_top("scene_selector")


func _on_shortcuts_pressed():
	game_manager.close_scene_on_top()
	game_manager.load_scene_on_top("scene_selector")
