extends KinematicBody2D

var health_sprite = preload("res://scenes/health.tscn")

var speed = 300
var max_health = 5
var current_health
var vel = Vector2()
var can_move


signal player_dead

onready var game_manager = get_node("/root/game_manager")
onready var sprite = get_node("sprite")
onready var health_area = get_node("canvas/health_area")

var t = 0

func _ready():
	game_manager.get_player_details()
	set_physics_process(true)
	can_move = false
	
func _on_spawn_timer_timeout():
	can_move = true

func _physics_process(delta):
	update_healthbar()
	do_move_animations()
	if can_move == true:
		do_move(delta)
	t += delta
	if t >= 3:
		# take_damage(1)
		t = 0

func do_move(delta):
	var input = Vector2(0, 0)
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	vel = input.normalized() * speed
	move_and_slide(vel)

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

func update_healthbar():
	for child in health_area.get_children():
		child.queue_free()
	var offset = Vector2(10, 0)
	for n in range(max_health):
		var h = health_sprite.instance()
		var ext = h.texture.get_size() * h.get_scale()
		if n >= current_health:
			h.modulate = Color(1, 1, 1, 0.2)
		var pos = Vector2(ext.x * n, 0) + offset * n
		h.set_position(pos)
		health_area.add_child(h)
		
func take_damage(dmg):
	current_health = clamp(current_health, 0, current_health - dmg)
	print("Took " + str(dmg) + " damage. Current health = " + str(current_health) + "/" + str(max_health))
	update_healthbar()
	update_player()

func update_player():
	game_manager.set_player_details(current_health)

