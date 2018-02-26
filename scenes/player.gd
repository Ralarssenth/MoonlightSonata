extends Area2D

var speed = 300
var vel = Vector2()

onready var sprite = get_node("sprite")

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	do_move(delta)
	do_move_animations()

func do_move(delta):
	var input = Vector2(0, 0)
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	vel = input.normalized() * speed
	var pos = get_position() + vel * delta
	set_position(pos)

func do_move_animations():
	if vel == Vector2(0, 0):
		sprite._set_playing(false)
		sprite.set_frame(0)
	elif vel.x > 0 and vel.y == 0:
		sprite.set_animation("right")
		sprite._set_playing(true)
	elif vel.x < 0 and vel.y == 0:
		sprite.set_animation("left")
		sprite._set_playing(true)
	elif vel.y < 0:
		sprite.set_animation("up")
		sprite._set_playing(true)
	elif vel.y > 0:
		sprite.set_animation("down")
		sprite._set_playing(true)