extends Node

# the game scenes that can be accessed by the game_manager
var title_scene = preload("res://scenes/title_screen.tscn")
var overworld_scene = preload("res://scenes/overworld.tscn")
var menu_scene = preload("res://scenes/menu.tscn")
var cabin0_scene = preload("res://scenes/cabin0.tscn")
var sewer_scene = preload("res://scenes/sewer.tscn")
var scene_selector_scene = preload("res://scenes/scene_selector.tscn")
# var game_over_scene = preload("res://scenes/game_over.tscn")

onready var canvas = get_node("canvas")

# a dictionary to look up the scene objects by a name
var scenes = { "title": title_scene,
				"overworld": overworld_scene,
				"menu": menu_scene,
				"cabin0": cabin0_scene,
				"sewer": sewer_scene,
				"scene_selector": scene_selector_scene}

#player stats
var player_data = { "max_health": 0,
					"current_health": 0,
					"max_stamina": 0,
					"current_stamina": 0,
					"speed": 0,
					"sprint_speed": 0,
					"sprint_stamina_cost": 0,
					"stamina_recovery_rate": 0,
					"out_of_stamina": false }					

# the current scene that the Player(person) is on
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
		current_primary_scene.set_pause_mode(Node.PAUSE_MODE_STOP)
	else:
		scenes_on_top[0].set_pause_mode(Node.PAUSE_MODE_STOP)
	scenes_on_top.push_front(scenes[scene_name].instance())
	canvas.add_child(scenes_on_top[0])
	get_tree().paused = true;
	
# closes the currently loaded scene on top and gives control back to the current scene (or top-most scene on top)
func close_scene_on_top():
	scenes_on_top[0].queue_free()
	scenes_on_top.remove(0)
	if scenes_on_top.empty():
		current_primary_scene.set_pause_mode(Node.PAUSE_MODE_INHERIT)
		get_tree().paused = false;
	else:
		scenes_on_top[0].set_pause_mode(Node.PAUSE_MODE_INHERIT)
		
# closes all scenes on top. useful for loading a new scene when several scenes on top are open
func close_all_scenes_on_top():
	var size = scenes_on_top.size() - 1
	while size >= 0:
		scenes_on_top[size].queue_free()
		scenes_on_top.remove(size)
		size -= 1
		
	get_tree().paused = false;
		
func _input(event):
	if event.is_action_pressed("ui_focus_next"):
		load_scene_on_top("menu")

func set_player_location(node_name, offset):
	var pos = current_primary_scene.get_node(node_name).get_position() + offset
	current_primary_scene.player.set_position(pos)

func set_player_details(player):
	if player.current_health <= 0:
		load_new_scene("title")
	player_data.max_health = player.max_health
	player_data.current_health = player.current_health
	player_data.max_stamina = player.max_stamina
	player_data.current_stamina = player.current_stamina
	player_data.speed = player.speed
	player_data.sprint_speed = player.sprint_speed
	player_data.sprint_stamina_cost = player.sprint_stamina_cost
	player_data.stamina_recovery_rate = player.stamina_recovery_rate
	player_data.out_of_stamina = player.out_of_stamina

func initialize_player():
	var player = current_primary_scene.get_node("player")
	if player_data.max_health == 0:
		player.load_defaults()
	else:
		player.max_health = player_data.max_health
		player.current_health = player_data.current_health
		player.max_stamina = player_data.max_stamina
		player.current_stamina = player_data.current_stamina
		player.speed = player_data.speed
		player.sprint_speed = player_data.sprint_speed
		player.sprint_stamina_cost = player_data.sprint_stamina_cost
		player.stamina_recovery_rate = player_data.stamina_recovery_rate
		player.out_of_stamina = player_data.out_of_stamina