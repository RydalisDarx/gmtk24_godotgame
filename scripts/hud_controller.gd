extends Control

@onready var TimerLabel = $"Temp Label"
@onready var PopupLabel = $"Popup Permanent"
var upgrade_text
var timer = 0


func _process(delta: float) -> void:
	if (timer > 0):
		var secs = fmod(timer, 60)
		var mils = fmod(timer, 1) *1000
		TimerLabel.text = "%s - %02d : %02d" % [upgrade_text,secs,mils]
		timer-=delta
	else:
		TimerLabel.text = " "
	pass

func _on_upgrade_collected(upgrade_name, permanent, duration):
	if(permanent):
		popup_text(upgrade_name)
	else:
		get_tree().create_timer(duration)
		timer = duration
		if (upgrade_name == "wall_cling"): 
			upgrade_text = "temporary wall cling"
		if (upgrade_name == "double_jump" or upgrade_name == "bonus_jump"):
			upgrade_text = "temporary midair jump"
		if (upgrade_name == "dash"):
			upgrade_text = "temporary forward dash"
		
		
func _on_upgrade_lost(upgrade_name):
	pass

func popup_text(text_to_display: String) -> void: 
	if (text_to_display == "wall_cling"): 
		PopupLabel.text = "You can now cling onto walls and wall jump!"
	if (text_to_display == "double_jump"):
		PopupLabel.text = "You can jump in midair permanently!"
	if (text_to_display == "dash"):
		PopupLabel.text = "You can dash forward by pressing shift!"
	$AnimationPlayer.play("PopupAnim")
	await get_tree().create_timer(4).timeout
	$AnimationPlayer.play_backwards("PopupAnim")


func _on_timer_timeout() -> void:
	pass # Replace with function body.
