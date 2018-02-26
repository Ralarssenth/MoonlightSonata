extends Node

# the game scenes that can be accessed by the game_manager
var title_scene = preload("res://scenes/title_screen.tscn")
var overworld_scene = preload("res://scenes/overworld.tscn")
var button_scene = preload("res://scenes/Button.tscn")
# var game_over_scene = preload("res://scenes/game_over.tscn")

# a dictionary to look up the scene objects by a name
var scenes = { "title": title_scene,
				"overworld": overworld_scene,
				"button": button_scene }

# the current scene that the player is on
var current_primary_scene

# an array of scenes currently displaying on top of other scenes and taking control
var scenes_on_top = []

# sets the current scene to the title screen and loads in into the tree
func _ready():
	current_primary_scene = title_scene.instance()
	add_child(current_primary_scene)
	set_process_input(true)
	
# removes the current scene from the tree and then loads a new current scene into the tree by name
func load_new_scene(scene_name):
	current_primary_scene.queue_free()
	current_primary_scene = scenes[scene_name].instance()	
	add_child(current_primary_scene)

# loads a scene into the tree on top of the current scene and gives the scene on top control
func load_scene_on_top(scene_name):
	if scenes_on_top.empty():
		stop_all_processing(current_primary_scene)
	else:
		stop_all_processing(scenes_on_top[0])
	scenes_on_top.push_front(scenes[scene_name].instance())
	add_child(scenes_on_top[0])
	
# closes the currently loaded scene on top and gives control back to the current scene
func close_scene_on_top():
	scenes_on_top[0].queue_free()
	scenes_on_top.remove(0)
	if scenes_on_top.empty():
		start_all_processing(current_primary_scene)
	else:
		start_all_processing(scenes_on_top[0])
		
func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		load_scene_on_top("button")
		
func stop_all_processing(scene):
	scene.set_process(false)
	scene.set_physics_process(false)
	scene.set_process_input(false)
	for child in scene.get_children():
		child.set_process(false)
		child.set_physics_process(false)
		child.set_process_input(false)
	
func start_all_processing(scene):
	scene.set_process(true)
	scene.set_physics_process(true)
	scene.set_process_input(true)
	for child in scene.get_children():
		child.set_process(true)
		child.set_physics_process(true)
		child.set_process_input(true)
