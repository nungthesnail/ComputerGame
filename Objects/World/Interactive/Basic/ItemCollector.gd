extends Area2D


@export var active : bool = false
@export var remain : int = 1
@export var item_class : Script = null
@export var hint_text : String = "Нажмите [E] чтобы подобрать предмет"
@export var play_dialog : bool = true


func get_hint():
	return hint_text


func interact():
	if remain <= 0 || !item_class || !active:
		return
	
	var item = item_class.new()
	Inventory.push_item(item, play_dialog)
	remain -= 1
	if remain <= 0:
		queue_free()


func _process(delta):
	$CollisionShape.disabled = !active
