extends Node

onready var game_manager = get_node("/root/game_manager")
onready var player = get_node("player")
onready var camera = get_node("camera")
onready var camera_tween = get_node("camera/camera_tween")
onready var canvas_modulate = $canvas_modulate
onready var canvas_modulate_tween = $canvas_modulate/canvas_modulate_tween

var screensize
var time_of_day = { "day": Color(1, 1, 1, 1),
					"afternoon": Color(.91, .88, .69, 1),
					"night": Color(.68, .64, .88, 1) }
var tod = "day"
var day_timer = 0

func _ready():
	screensize = get_viewport().size
	set_physics_process(true)

func _physics_process(delta):
	move_camera(false)
	day_timer += delta
	if day_timer >= 10:
		change_time_of_day()
		day_timer = 0
	
func change_time_of_day():
	if tod == "day":
		tod = "afternoon"
	elif tod == "afternoon":
		tod = "night"
	elif tod == "night":
		tod = "day"
	canvas_modulate_tween.interpolate_property(canvas_modulate, "color", canvas_modulate.color, time_of_day[tod],
												.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	canvas_modulate_tween.start()
		
		
	
func move_camera(should_camera_warp):
	var x = player.position.x
	var y = player.position.y
	if x < 0:
		x -= screensize.x
	if y < 0:
		y -= screensize.y
	var new_x = int(x / screensize.x) * screensize.x
	var new_y = int(y / screensize.y) * screensize.y
	var new_pos = Vector2(new_x, new_y)
	if should_camera_warp:
		camera.set_position(new_pos)
	else:
		camera_tween.interpolate_property(camera, "position", camera.position, new_pos, 0.001, Tween.TRANS_LINEAR, Tween.EASE_IN)
		camera_tween.start()

func _on_cabin0_door_area_entered( area ):
	game_manager.load_new_scene("cabin0")
	game_manager.set_player_location("door", Vector2(0, 50))

func _on_well0_door_area_entered( area ):
	game_manager.load_new_scene("sewer")
	game_manager.set_player_location("door0", Vector2(0, 50))

func _on_well1_door_area_entered( area ):
	game_manager.load_new_scene("sewer")
	game_manager.set_player_location("door1", Vector2(0, 50))
