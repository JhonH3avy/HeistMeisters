extends Node

var Player
var navigation
var destinations


var night_vision_on_sfx = "res://SFX/nightvision.wav"
var night_vision_off_sfx = "res://SFX/nightvision_off.wav"

var box_sprite = "res://GFX/PNG/Tiles/tile_129.png"
var player_sprite = "res://GFX/PNG/Hitman 1/hitman1_stand.png"

var box_occluder = "res://Scenes/Characters/BoxOccluder.tres"
var player_occluder = "res://Scenes/Characters/CharacterOccluder.tres"

var box_collision_shape = "res://Scenes/Characters/BoxCollisionShape.tres"
var player_collision_shape = "res://Scenes/Characters/CharacterCollisionShape.tres"