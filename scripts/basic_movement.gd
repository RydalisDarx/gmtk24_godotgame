extends CharacterBody2D

@export var speed := 500.0
@export var jump_strength := -500.0
@export var gravity := 950.0
@export var terminal_velocity := 700
@export var dash_speed := 2500.0

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
	# DEBUG
	#print(cayote_timer)
	#if velocity.y != 0:
		#print("PLAYER: velocity.y = " + str(velocity.y))

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
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

	# Cayote Time
	if is_on_floor():
		cayote_timer = cayote_time
	else:
		cayote_timer -= delta

	# Only allow jumping when on the ground
	if Input.is_action_just_pressed("jump") and cayote_timer > 0 and is_on_floor():
		if upgrades["double_jump"]:
			powers["double_jump"] = true
		velocity.y = jump_strength
		
	if Input.is_action_just_pressed("jump") and !is_on_floor() and powers["double_jump"]:
		powers["double_jump"] = false
		velocity.y = jump_strength
	
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

func _on_item_acquistion_hitbox_upgrade_collected(upgrade_name):
	print("PLAYER: Got upgrade " + str(upgrade_name))
	if upgrades.has(upgrade_name):
		upgrades[upgrade_name] = true
