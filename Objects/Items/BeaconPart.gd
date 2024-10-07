extends BaseItem

func _init():
	item_id = "beacon_part"
	item_name = "Деталь маяка"
	description = "Деталь от маяка. Нужна для его восстановления."
	icon_path = "res://Sprites/Items/Items.png"
	icon_region = Rect2i(8,0,8,8)
	locked = true
