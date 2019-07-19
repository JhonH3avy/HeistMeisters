extends NinePatchRect

func _ready():
	visible = false


func collect_loot(sprite_path):
	visible = true
	var sprite = load(sprite_path)
	$LootList.add_icon_item(sprite, false)