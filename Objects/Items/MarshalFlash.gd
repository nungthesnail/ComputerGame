extends BaseItem


func _init():
	item_id = "marshal_flash"
	item_name = "Флешка Маршала"
	description = "Флеш-накопитель на 128гб. Заполнена секретными файлыми правительства."
	icon_path = "res://Sprites/Items/Items.png"
	icon_region = Rect2i(24,0,8,8)
	locked = true
