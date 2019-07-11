extends ItemList

onready var box_sprite = load(Global.box_sprite)

func update_disguises(number):
	clear()
	for i in range(number):
		add_icon_item(box_sprite, false)
