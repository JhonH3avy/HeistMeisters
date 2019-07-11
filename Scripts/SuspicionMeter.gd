extends TextureProgress

export var suspicion_step : float= 1
export var suspicion_dropoff : float = 0.25

var suspicion = 0

func _process(delta):
	suspicion = clamp(suspicion - suspicion_dropoff, min_value, max_value)
	value = suspicion


func player_seen():
	suspicion += suspicion_step
	if suspicion == max_value:
		end_game()


func end_game():
	get_tree().quit()
