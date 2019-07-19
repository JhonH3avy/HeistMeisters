extends "res://Scripts/Character.gd"


export var disguises = 3 # How many disguises you start with
export var disguse_duration = 5 # How long disguise can last
export var disguise_slowdown = 0.25

var motion = Vector2()

var is_disguised = false
var velocity_multiplier = 1

enum available_vision_modes {DARK, NIGHT_VISION}

var vision_mode

onready var box_occluder = load(Global.box_occluder)
onready var box_sprite = load(Global.box_sprite)
onready var box_collision_shape = load(Global.box_collision_shape)

onready var player_occluder = load(Global.player_occluder)
onready var player_sprite = load(Global.player_sprite)
onready var player_collision_shape = load(Global.player_collision_shape)



func _ready():
	Global.Player = self
	vision_mode = available_vision_modes.DARK
	get_tree().call_group("vision_interface", "dark_vision_mode")
	get_tree().call_group("disguise_ui", "update_disguises", disguises)	
	reveal()


func _process(delta):
	update_motion(delta)
	move_and_slide(motion * velocity_multiplier)
	if is_disguised:
		$DisguiseLifetimeFeedback.rect_rotation = -rotation_degrees
		$DisguiseLifetimeFeedback.text = str($DisguiseLifetime.time_left).pad_decimals(2)


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
	if Input.is_action_just_pressed("toggle_disguise"):
		toggle_disguise()


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
	

func toggle_disguise():
	if is_disguised:
		reveal()
	elif disguises > 0:
		disguise()
	

func disguise():
	disguises -= 1
	$DisguiseLifetimeFeedback.show()
	$Sprite.texture = box_sprite
	$Light2D.texture = box_sprite
	$LightOccluder2D.occluder = box_occluder
	$CollisionShape2D.shape = box_collision_shape
	collision_layer = 16
	velocity_multiplier = disguise_slowdown
	$DisguiseLifetime.start()
	is_disguised = true
	get_tree().call_group("disguise_ui", "update_disguises", disguises)
	

func reveal():
	$DisguiseLifetimeFeedback.hide()
	$Sprite.texture = player_sprite
	$Light2D.texture = player_sprite
	$LightOccluder2D.occluder = player_occluder	
	$CollisionShape2D.shape = player_collision_shape
	collision_layer = 1
	velocity_multiplier = 1
	is_disguised = false
	

func collect_briefcase():
	var loot = Node.new()
	loot.set_name("briefcase")
	add_child(loot)
	get_tree().call_group("loot", "collect_loot", Global.briefcase_sprite)
		

func get_briefcase():
	var briefcase = get_node("briefcase")
	return briefcase == null