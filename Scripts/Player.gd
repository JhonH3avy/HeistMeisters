extends "res://Scripts/Character.gd"

var motion = Vector2()
var vision_mode

enum available_vision_modes {DARK, NIGHT_VISION}


func _ready():
	Global.Player = self
	vision_mode = available_vision_modes.DARK
	get_tree().call_group("vision_interface", "dark_vision_mode")


func _process(delta):
	update_motion(delta)
	motion = move_and_slide(motion)


func update_motion(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("player_left") and not Input.is_action_pressed("player_right"):
		motion.x = clamp(motion.x - SPEED, -MAX_SPEED, 0) 
	elif Input.is_action_pressed("player_right") and not Input.is_action_pressed("player_left"):
		motion.x = clamp(motion.x + SPEED, 0, MAX_SPEED)
	else:
		motion.x = lerp(motion.x, 0, FRICTION)
	if Input.is_action_pressed("player_up") and not Input.is_action_pressed("player_down"):
		motion.y = clamp(motion.y - SPEED, -MAX_SPEED, 0) 
	elif Input.is_action_pressed("player_down") and not Input.is_action_pressed("player_up"):
		motion.y = clamp(motion.y + SPEED, 0, MAX_SPEED)
	else:
		motion.y = lerp(motion.y, 0, FRICTION)
		
		
func _input(event):
	if Input.is_action_just_pressed("vision_mode_switch") and $VisionChangeCooldown.is_stopped():
		$VisionChangeCooldown.start()
		cycle_vision_mode()


func cycle_vision_mode():
	if vision_mode == available_vision_modes.DARK:
		get_tree().call_group("vision_interface", "night_vision_mode")
		vision_mode = available_vision_modes.NIGHT_VISION
		play_vision_change_sfx(Global.night_vision_on_sfx)
	elif vision_mode == available_vision_modes.NIGHT_VISION:
		get_tree().call_group("vision_interface", "dark_vision_mode")
		vision_mode = available_vision_modes.DARK
		play_vision_change_sfx(Global.night_vision_off_sfx)
		

func _on_VisionChangeCooldown_timeout():
	$VisionChangeCooldown.stop()


func play_vision_change_sfx(sfx_path):
	$AudioStreamPlayer.stream = load(sfx_path)
	$AudioStreamPlayer.play()