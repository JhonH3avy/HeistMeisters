extends CanvasModulate

export var dark_color : Color
export var night_vision_color : Color

func _ready():
	add_to_group("vision_interface")
	color = dark_color
	

func night_vision_mode():
	color = night_vision_color
	
	
func dark_vision_mode():
	color = dark_color
