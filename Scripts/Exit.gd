extends ColorRect

export var requirements = []


func _on_Area2D_body_entered(body):
	if has_met_requirements(body):
		get_tree().change_scene("res://Scenes/VictoryScreen.tscn")


func has_met_requirements(player):
	for requirement in requirements:
		if not player.has_node("briefcase"):
			return false
	return true