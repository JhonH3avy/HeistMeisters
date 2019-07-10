extends Popup

onready var display = $VSplitContainer/DisplayContainer/Display
onready var light = $VSplitContainer/ButtonContainer/ButtonGrid/Light
onready var audio = $AudioStreamPlayer

export var red_light_sprite : Texture
export var green_light_sprite : Texture

export var button_push_sfx : AudioStream
export var combination_correct_sfx : AudioStream

export var combination = []
var guess = []

signal combination_correct


func _ready():
	connect_buttons()
	reset_lock()


func connect_buttons():
	for child in $VSplitContainer/ButtonContainer/ButtonGrid.get_children():
		if child is Button:
			child.connect("pressed", self, "_on_button_pressed", [child.text])


func _on_button_pressed(button):	
	if button == "OK":
		check_guess()
	else:
		enter(int(button))


func check_guess():
	if guess == combination:
		open_lock()
	else:
		reset_lock()


func enter(button):
	audio.stream = button_push_sfx
	audio.play()
	guess.append(button)
	update_display()
	

func reset_lock():
	display.clear()
	guess.clear()
	light.texture = red_light_sprite
	
	
func open_lock():
	audio.stream = combination_correct_sfx
	audio.play()
	light.texture = green_light_sprite
	$Timer.start()


func update_display():
	display.bbcode_text = "[center]" + PoolStringArray(guess).join("") + "[/center]"
	if guess.size() == combination.size():
		check_guess()

func _on_Timer_timeout():
	emit_signal("combination_correct")
	hide()
	reset_lock()
