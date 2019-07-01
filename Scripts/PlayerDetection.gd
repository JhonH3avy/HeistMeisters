extends "res://Scripts/Character.gd"

export var FOV_TOLERANCE = 20
export var MAX_DETECTION_RANGE = 320

export var detection_color : Color
export var neutral_color: Color

onready var Player = get_node("/root/Level1/Player")


# warning-ignore:unused_argument
func _process(delta):
	if Player_is_in_FOV_TOLERANCE() and Player_is_in_LOS():
		$Torch.color = detection_color
	else:
		$Torch.color = neutral_color


func Player_is_in_FOV_TOLERANCE():
	var NPC_facing_direction = Vector2(1,0).rotated(global_rotation)
	var direction_to_player = (Player.position - global_position).normalized()
	
	if abs(direction_to_player.angle_to(NPC_facing_direction)) < deg2rad(FOV_TOLERANCE):
		return true
	else:
		return false
		
		
func Player_is_in_LOS():
	var space = get_world_2d().direct_space_state
	var LOS_obstacle = space.intersect_ray(global_position, Player.global_position, [self], collision_mask)
	
	var distance_to_Player = Player.global_position.distance_to(global_position)
	var Player_in_range = distance_to_Player < MAX_DETECTION_RANGE
	
	if LOS_obstacle.collider == Player and Player_in_range:
		return true
	else:
		return false