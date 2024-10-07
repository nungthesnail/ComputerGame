extends Control


var selector : int = 0
var cur_label : Label = null
var label_def_text : String = ""


func _ready():
	update_list()


func clear_list():
	for c in $HBoxContainer/ScrollLeft/MarginContainer/LeftContainer.get_children():
		c.queue_free()


func update_list():
	clear_list()
	for i in Inventory.cells:
		var label = Label.new()
		if i is BaseItem:
			label.text = i.item_name
		else:
			label.text = "[ Пусто ]"
		$HBoxContainer/ScrollLeft/MarginContainer/LeftContainer.add_child(label)
	
	cur_label = get_list_element(selector)
	if is_instance_valid(cur_label):
		label_def_text = cur_label.text
		cur_label.text = "> %s" % [cur_label.text]
		update_item_data()


func update_item_data():
	var item = Inventory.get_item(selector)
	if item is BaseItem:
		var texture = AtlasTexture.new()
		if ResourceLoader.exists(item.icon_path):
			texture = AtlasTexture.new()
			texture.atlas = load(item.icon_path)
			texture.region = item.icon_region
		else:
			texture.atlas = load("res://Sprites/Items/Items.png")
			texture.region = Rect2(112,0,16,16)
		$HBoxContainer/ScrollRight/Margin/RightContainer/Icon.texture = texture
		$HBoxContainer/ScrollRight/Margin/RightContainer/ItemName.text = "Название предмета: %s" % [item.item_name]
		$HBoxContainer/ScrollRight/Margin/RightContainer/Description.text = "Описание: %s" % [item.description]
	
	else:
		var texture = AtlasTexture.new()
		texture.atlas = load("res://Sprites/Items/Items.png")
		texture.region = Rect2(112,0,16,16)
		$HBoxContainer/ScrollRight/Margin/RightContainer/Icon.texture = texture
		$HBoxContainer/ScrollRight/Margin/RightContainer/ItemName.text = "Название предмета: -"
		$HBoxContainer/ScrollRight/Margin/RightContainer/Description.text = "Описание: -"


func get_list_element(idx : int):
	return $HBoxContainer/ScrollLeft/MarginContainer/LeftContainer.get_child(idx)


func _process(delta):
	selector = clamp(selector, 0, $HBoxContainer/ScrollLeft/MarginContainer/LeftContainer.get_child_count() - 1)
	if Inventory.get_item(selector) is BaseItem:
		$HBoxContainer/ScrollRight/Margin/RightContainer/Throw.disabled = Inventory.get_item(selector).locked
	
	if Input.is_action_just_pressed("up"):
		if is_instance_valid(cur_label):
			cur_label.text = label_def_text
		selector = clamp(selector - 1, 0, $HBoxContainer/ScrollLeft/MarginContainer/LeftContainer.get_child_count() - 1)
		cur_label = get_list_element(selector)
		
		if is_instance_valid(cur_label):
			label_def_text = cur_label.text
			cur_label.text = "> %s" % [cur_label.text]
			update_item_data()
	
	if Input.is_action_just_pressed("down"):
		if is_instance_valid(cur_label):
			cur_label.text = label_def_text
		selector = clamp(selector + 1, 0, $HBoxContainer/ScrollLeft/MarginContainer/LeftContainer.get_child_count() - 1)
		cur_label = get_list_element(selector)
		
		if is_instance_valid(cur_label):
			label_def_text = cur_label.text
			cur_label.text = "> %s" % [cur_label.text]
			update_item_data()


func throw_button():
	if Inventory.get_item(selector) is BaseItem:
		if !Inventory.get_item(selector).locked:
			Inventory.pull_item(selector)
			update_list()
