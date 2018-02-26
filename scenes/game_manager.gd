extends Node

# the game scenes that can be accessed by the game_manager
var title_scene = preload("res://scenes/title_screen.tscn")
var overworld_scene = preload("res://scenes/overworld.tscn")
# var game_over_scene = preload("res://scenes/game_over.tscn")

# a dictionary to look up the scene objects by a name
var scenes = { "title": title_scene,
				"overworld": overworld_scene }

# the current scene that the player is on
var current_primary_scene

# a scene currently displaying on top of the main scene and taking control
var scene_on_top

# sets the current scene to the title screen and loads in into the tree
func _ready():
	current_primary_scene = title_scene.instance()
	add_child(current_primary_scene)
	
# removes the current scene from the tree and then loads a new current scene into the tree by name
func load_new_scene(scene_name):
	current_primary_scene.queue_free()
	current_primary_scene = scenes[scene_name].instance()	
	add_child(current_primary_scene)

# loads a scene into the tree on top of the current scene and gives the scene on top control
func load_scene_on_top(scene_name):
	scene_on_top = scenes[scene_name].instance()
	current_primary_scene.set_process(false)
	add_child(scene_on_top)
	
# closes the currently loaded scene on top and gives control back to the current scene
func close_scene_on_top():
	scene_on_top.queue_free()
	current_primary_scene.set_process(true)
