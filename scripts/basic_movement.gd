extends CharacterBody2D

@export var speed := 500.0
@export var jump_strength := -500.0
@export var gravity := 950.0
@export var terminal_velocity := 700
@export var dash_speed := 2500.0

@export_range(2.0, 5.0) var overtime_gravity_increment := 30.0
@export_range(0.1, 0.0) var cayote_time := 0.07 
@export_range(0.0, 1.0) var friction = 0.8
@export_range(0.0 , 1.0) var acceleration = 0.25

var overtime_gravity := 0.0
var cayote_timer := 0.0

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
	if Input.is_action_just_pressed("jump") and cayote_timer > 0:
		velocity.y = jump_strength
	
	# Cut off jump velocity when releasing the jump button
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = 0
		
	if Input.is_action_just_pressed("dash"):
		if velocity.x > 0:
			velocity.x += dash_speed
		elif velocity.x < 0:
			velocity.x -= dash_speed

	move_and_slide()
