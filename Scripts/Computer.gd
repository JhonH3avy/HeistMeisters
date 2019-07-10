extends Area2D

export var combination_length : int = 4

var can_click = false
var combination

signal combination_generated


func _ready():
	$Light2D.enabled = false
	generate_combination()
	emit_signal("combination_generated", combination)


func _on_Computer_body_entered(body):
	can_click = true
	


func _on_Computer_body_exited(body):
	can_click = false
	$Light2D.enabled = false
	$CanvasLayer/ComputerPopup.hide()
	
	
func _input_event(viewport, event, shape_idx):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_click:
		$CanvasLayer/ComputerPopup.popup_centered()
		$Light2D.enabled = true
		
		
func generate_combination():
	var combination_generator = get_tree().get_root().find_node("CombinationGenerator", true, false)
	combination = combination_generator.generate_combination(combination_length)
	set_popup_text()


func set_popup_text():
	$CanvasLayer/ComputerPopup.set_text(PoolStringArray(combination).join(""))