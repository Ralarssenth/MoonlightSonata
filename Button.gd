extends Button

onready var game_manager = get_node("/root/game_manager")
onready var label = get_node("Label")

func _ready():
	label.set_text(str(game_manager.scenes_on_top.size()))
	set_process(true)

func _on_Button_pressed():
	game_manager.close_scene_on_top()
