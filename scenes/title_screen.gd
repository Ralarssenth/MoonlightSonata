extends Sprite

# get the game manager that sits at the root of the game tree to handle global values and scene changes 
onready var game_manager = get_node("/root/game_manager")

func _ready():
	set_process(true)

func _process(delta):
	if Input.is_action_pressed("ui_select") || Input.is_action_pressed("ui_accept"):
		game_manager.load_new_scene("cabin0")
