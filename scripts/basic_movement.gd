extends CharacterBody2D

@export var speed := 200.0
@export var jump_strength := -300.0
@export var gravity := 250.0
@export var terminal_velocity := 200
@export var dash_speed := 1000.0

@onready var animation_tree := $"%AnimationTree"
var current_animation := ""
var previous_animation := ""

# dictionary of booleans setting whether an upgrade has been unlocked or not
@export var upgrades = {
	"double_jump" = false,
	"dash" = false
}

@export_range(2.0, 5.0) var overtime_gravity_increment := 30.0
@export_range(0.1, 0.0) var cayote_time := 0.07
@export_range(0.0, 3.0) var dash_cooldown_time := 1.0
@export_range(0.0, 1.0) var friction = 0.8
@export_range(0.0 , 1.0) var acceleration = 0.25

var overtime_gravity := 0.0
var cayote_timer := 0.0
var dash_timer := 0.0

# dictionary of booleans setting whether a power is able to be used moment to moment
var powers = {
	"double_jump" = false,
	"dash" = false
}

func _physics_process(delta):
	# Increase gravity intensity every frame off the ground
	if not is_on_floor():
		overtime_gravity += overtime_gravity_increment
	else:
		overtime_gravity = 0

	# Apply gravity
	velocity.y += (gravity + overtime_gravity) * delta
	clampf(velocity.y, -terminal_velocity, terminal_velocity)

	# Input affects x axis only
	var dir = Input.get_axis("walk_left", "walk_right")

	if dir != 0:
		update_animation_blend(dir)
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		animate("run")
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

		if is_on_floor():
			animate("idle")

	if not is_on_floor():
		animate("fall")

	if dir != 0 and is_on_floor() and previous_animation == 'fall':
		animate("land_run")

	# Cayote Time
	if is_on_floor():
		cayote_timer = cayote_time
	else:
		cayote_timer -= delta

	# Only allow jumping when on the ground
	if Input.is_action_just_pressed("jump") and cayote_timer > 0:
		if upgrades["double_jump"]:
			powers["double_jump"] = true
		velocity.y = jump_strength
		animate("jump")
		
	if Input.is_action_just_pressed("jump") and cayote_timer < 0 and powers["double_jump"]:
		powers["double_jump"] = false
		velocity.y = jump_strength
		animate("jump")
	
	# Cut off jump velocity when releasing the jump button
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = 0
		
	if dash_timer > 0:
		dash_timer -= delta
	else:
		if upgrades["dash"]:
			powers["dash"] = true
		dash_timer = 0
	
	# use dash
	if Input.is_action_just_pressed("dash") and powers["dash"]:
		if velocity.x > 0:
			velocity.x += dash_speed
		elif velocity.x < 0:
			velocity.x -= dash_speed
		powers["dash"] = false
		dash_timer = dash_cooldown_time

	move_and_slide()

func _on_item_acquistion_hitbox_upgrade_collected(upgrade_name, permanent, duration):
	print("PLAYER: Got upgrade " + str(upgrade_name))
	if upgrades.has(upgrade_name):
		upgrades[upgrade_name] = true
		if not permanent:
			print("will last " + str(duration) + " seconds")
			await get_tree().create_timer(duration).timeout
			upgrades[upgrade_name] = false
			print("PLAYER: upgrade " + str(upgrade_name) + " wore off")


func update_animation_blend(animation_blend: float):
	# this should be called every frame. uses a float to set which animations to play. -1 = left, 1 = right, 0 = right
	animation_tree["parameters/start_run/blend_position"] = animation_blend
	animation_tree["parameters/run/blend_position"] = animation_blend
	animation_tree["parameters/stop_run/blend_position"] = animation_blend
	animation_tree["parameters/jump/blend_position"] = animation_blend
	animation_tree["parameters/fall/blend_position"] = animation_blend
	animation_tree["parameters/land/blend_position"] = animation_blend
	animation_tree["parameters/land_run/blend_position"] = animation_blend

func animate(animation_name: String):
	if current_animation == animation_name:
		return

	previous_animation = current_animation
	current_animation = animation_name

	animation_tree["parameters/playback"].travel(animation_name)
