extends CharacterBody2D
class_name Player

@export var speed := 200.0
@export var jump_strength := -300.0
@export var gravity := 675.0
@export var terminal_velocity := 500
@export var dash_speed := 1000.0

@onready var animation_tree := $"%AnimationTree"
var current_animation := ""

var m_Properties : PlayerProperties = null

# dictionary of booleans setting whether an upgrade is active
@export var active_upgrades = {
	"bonus_jump" = false,
	"double_jump" = false,
	"dash" = false,
	"wall_cling" = true
}

@export_range(2.0, 5.0) var overtime_gravity_increment := 30.0
@export_range(0.1, 0.0) var cayote_time := 0.07
@export_range(0.0, 3.0) var dash_cooldown_time := 1.0
@export_range(0.0, 3.0) var wj_cooldown_time := 1.25
@export_range(0.0, 1.0) var wj_time_before_slide := 0.25
@export_range(0.0, 1.0) var friction = 0.8
@export_range(0.0 , 1.0) var acceleration = 0.25

var dir := 0
var overtime_gravity := 0.0
var cayote_timer := 0.0
var dash_timer := 0.0
var wj_timer := 0.0
var wj_slide_timer := 0.0
var last_wj_dir := 0

# dictionary of booleans setting whether a power is ready to be used moment to moment
var ready_powers = {
	"bonus_jump" = false,
	"double_jump" = false,
	"dash" = false,
	"wall_jump" = false
}

# Returns the player proeprties object
func GetProperties() -> PlayerProperties:
	return m_Properties
	 
# Set the player properties
func SetProperties(properties: PlayerProperties) -> void:
	var perm_upgrades = properties.permanent_upgrades
	m_Properties = PlayerProperties.new(perm_upgrades)
	
	for upgrade in perm_upgrades.keys():
		active_upgrades[upgrade] = perm_upgrades[upgrade]

func _physics_process(delta):
	# Increase gravity intensity every frame off the ground
	if not is_on_floor():
		overtime_gravity += overtime_gravity_increment
	else:
		overtime_gravity = 0

	# Input affects x axis only
	if wj_timer < wj_cooldown_time - 0.15: #not set if just wall jumped
		dir = Input.get_axis("walk_left", "walk_right")

	if dir != 0:
		update_animation_blend(dir)
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		animate("run")
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)

		if is_on_floor():
			animate("idle")

	# Apply gravity
	velocity.y += (gravity + overtime_gravity) * delta
	if active_upgrades["wall_cling"] and is_on_wall() and velocity.y > 0 and dir != 0:
		velocity.y = clampf(velocity.y, 0.25 * -terminal_velocity, 0.25 * terminal_velocity)
		if wj_slide_timer > 0:
			velocity.y = 0.0
	else:
		velocity.y = clampf(velocity.y, -terminal_velocity, terminal_velocity)

	if not is_on_floor():
		animate("fall")

	# Cayote Time
	if is_on_floor():
		cayote_timer = cayote_time
	else:
		cayote_timer -= delta

	if dash_timer > 0:
		dash_timer -= delta
	else:
		if active_upgrades["dash"]:
			ready_powers["dash"] = true
		dash_timer = 0
		
	if is_on_wall():
		wj_slide_timer -= delta
	else:
		wj_slide_timer = wj_cooldown_time
		
	if wj_timer > 0:
		wj_timer -= delta
	else:
		if active_upgrades["wall_cling"]:
			ready_powers["wall_jump"] = true
		wj_timer = 0

	# Jump under various circumstances
	if Input.is_action_just_pressed("jump"):
		# Jump off ground
		if cayote_timer > 0:
			if active_upgrades["double_jump"]:
				ready_powers["double_jump"] = true
			if active_upgrades["bonus_jump"]:
				ready_powers["bonus_jump"] = true
			velocity.y = jump_strength
			animate("jump")
		# Wall jump
		elif is_on_wall_only() and (ready_powers["wall_jump"] or last_wj_dir != dir):
			overtime_gravity = 0
			velocity.y = jump_strength * 1.5
			velocity.x = jump_strength * 2 * dir
			wj_timer = wj_cooldown_time	
			ready_powers["wall_jump"] = false
			last_wj_dir = dir
			dir *= -1
		# Mid-air jump
		elif ready_powers["double_jump"] or ready_powers["bonus_jump"]:
			if ready_powers["double_jump"]:
				ready_powers["double_jump"] = false
			else:
				ready_powers["bonus_jump"] = false
			overtime_gravity = 0
			velocity.y = jump_strength
			animate("jump")
	
	# Cut off jump velocity when releasing the jump button
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = 0
			
	# use dash
	if Input.is_action_just_pressed("dash") and ready_powers["dash"]:
		if velocity.x > 0:
			velocity.x += dash_speed
		elif velocity.x < 0:
			velocity.x -= dash_speed
		ready_powers["dash"] = false
		dash_timer = dash_cooldown_time

	move_and_slide()

func _on_item_acquistion_hitbox_upgrade_collected(upgrade_name, permanent, duration):
	print("PLAYER: Got upgrade " + str(upgrade_name))
	if active_upgrades.has(upgrade_name):
		var had_upgrade = active_upgrades[upgrade_name]
		active_upgrades[upgrade_name] = true
		if permanent:
			m_Properties.set_upgrade(upgrade_name, true)
		if not permanent and had_upgrade == false:
			print("will last " + str(duration) + " seconds")
			await get_tree().create_timer(duration).timeout
			active_upgrades[upgrade_name] = false
			print("PLAYER: upgrade " + str(upgrade_name) + " wore off")
			
func _on_hazard_collision():
	print("death")
	call_deferred("reload")
	
func reload():
	get_tree().reload_current_scene()


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

	animation_tree["parameters/playback"].travel(animation_name)
