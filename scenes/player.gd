extends KinematicBody2D

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# The player's default stats. These get loaded when a new game starts. If you want to add a new 
# property to the player, you have to add it here and several other places. Here's a list of the
# places I currently know of. If you make any more, try to add them to this list:
#
# 	player.default_stats in player.gd (here)
# 	create a property in player and default it to the default_stats value
# 	player.update_player()
# 	player.load_defaults()
# 	game_manager.player_data object
# 	game_manager.set_player_details(player)
# 	game_manager.initialize_player()
#
# Sorry it's so many. Maybe we can trhink of a better way to do it some day...
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
const default_stats = { "max_health": 5,
						"current_health": 5,
						"max_stamina": 1000,
						"current_stamina": 1000,
						"speed": 150,
						"sprint_speed": 300,
						"sprint_stamina_cost": 10,
						"stamina_recovery_rate": 5,
						"out_of_stamina": false }

var health_sprite = preload("res://scenes/health.tscn")

var max_health = default_stats.max_health
var current_health = default_stats.current_health
var max_stamina = default_stats.max_stamina
var current_stamina = default_stats.current_stamina
var speed = default_stats.speed
var sprint_speed = default_stats.sprint_speed
var sprint_stamina_cost = default_stats.sprint_stamina_cost
var stamina_recovery_rate = default_stats.stamina_recovery_rate
var out_of_stamina = default_stats.out_of_stamina

var vel = Vector2()
var can_move
var sprinting = false

signal player_dead

onready var game_manager = get_node("/root/game_manager")
onready var sprite = get_node("sprite")
onready var health_area = get_node("canvas/health_area")
onready var stamina_bar = $canvas/stamina_bar

var t = 0

func _ready():
	game_manager.initialize_player()
	set_physics_process(true)
	can_move = false
	
func _on_spawn_timer_timeout():
	can_move = true

func _physics_process(delta):
	update_healthbar()
	do_sprint_update_stamina_bar()
	do_move_animations()
	if can_move == true:
		do_move(delta)
	t += delta
	if t >= 2:
		# take_damage(1)
		t = 0

func do_move(delta):
	var input = Vector2(0, 0)
	input.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	input.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	if sprinting:
		vel = input.normalized() * sprint_speed
	else:
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

func do_sprint_update_stamina_bar():
	if Input.is_action_pressed("player_sprint") and not out_of_stamina:
		sprinting = true
	else:
		sprinting = false
	if sprinting:
		current_stamina -= sprint_stamina_cost
	else:
		current_stamina += stamina_recovery_rate
			
	current_stamina = clamp(current_stamina, 0, max_stamina)
	if current_stamina == 0:
		out_of_stamina = true
	if current_stamina == max_stamina:
		out_of_stamina = false
	stamina_bar.max_value = max_stamina
	stamina_bar.value = current_stamina
	update_player()
		
func take_damage(dmg):
	current_health = clamp(current_health, 0, current_health - dmg)
	print("Took " + str(dmg) + " damage. Current health = " + str(current_health) + "/" + str(max_health))
	update_healthbar()
	update_player()

func update_player():
	var current_stats = { "max_health": max_health,
						"current_health": current_health,
						"max_stamina": max_stamina,
						"current_stamina": current_stamina,
						"speed": speed,
						"sprint_speed": sprint_speed,
						"sprint_stamina_cost": sprint_stamina_cost,
						"stamina_recovery_rate": stamina_recovery_rate,
						"out_of_stamina": out_of_stamina }
	game_manager.set_player_details(current_stats)
	
func load_defaults():
	max_health = default_stats.max_health
	current_health = default_stats.current_health
	max_stamina = default_stats.max_stamina
	current_stamina = default_stats.current_stamina
	speed = default_stats.speed
	sprint_speed = default_stats.sprint_speed
	sprint_stamina_cost = default_stats.sprint_stamina_cost
	stamina_recovery_rate = default_stats.stamina_recovery_rate
	out_of_stamina = default_stats.out_of_stamina