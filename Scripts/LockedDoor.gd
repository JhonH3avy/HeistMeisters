extends "res://Scripts/Door.gd"

var combination


func _ready():
	init_label()


func _input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_click:
		$CanvasLayer/NumberPad.popup_centered()
		
func _on_Door_body_exited(body):
	if body == Global.Player:
		can_click = false
		$CanvasLayer/NumberPad.hide()
		$CanvasLayer/NumberPad.reset_lock()

func _on_NumberPad_combination_correct():
	open()


func init_label():
	$Label.rect_pivot_offset = $Label.rect_size / 2
	$Label.rect_rotation = -rotation_degrees


func _on_Computer_combination_generated(generated_combination, lock_group):
	combination = generated_combination
	$CanvasLayer/NumberPad.combination = combination
	$Label.text = lock_group


func _on_ExitDetection_body_entered(body):
	open()


func night_vision_mode():
	$Label.percent_visible = 1
	
	
func dark_vision_mode():
	$Label.percent_visible = 0