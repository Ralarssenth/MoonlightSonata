extends Node

onready var game_manager = get_node("/root/game_manager")
onready var player = get_node("player")
onready var camera = get_node("camera")
onready var camera_tween = get_node("camera/camera_tween")

var screensize

func _ready():
	screensize = get_viewport().size
	set_physics_process(true)

func _physics_process(delta):
	move_camera()
	
func move_camera():
	var x = player.position.x
	var y = player.position.y
	if x < 0:
		x -= screensize.x
	if y < 0:
		y -= screensize.y
	var new_x = int(x / screensize.x) * screensize.x
	var new_y = int(y / screensize.y) * screensize.y
	var new_pos = Vector2(new_x, new_y)
	camera_tween.interpolate_property(camera, "position", camera.position, new_pos, 0.001, Tween.TRANS_LINEAR, Tween.EASE_IN)
	camera_tween.start()

func _on_door0_area_entered( area ):
	game_manager.load_new_scene("overworld")
	game_manager.set_player_location("well0_door", Vector2(0, -75))

func _on_door1_area_entered( area ):
	game_manager.load_new_scene("overworld")
	game_manager.set_player_location("well1_door", Vector2(0, -75))

func _on_locked_door0_area_entered( area ):
	var opening = get_node("locked_door0/animation")
	opening.set_animation("opening")
	opening._set_playing(true)
