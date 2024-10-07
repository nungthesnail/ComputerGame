extends Node


class InventoryCell:
	var value : int = 0


var amount : int = 5
var cells : Array[BaseItem] = []


func _init():
	for c in range(amount):
		cells.append(null)


func push_item(item : BaseItem, play_dialog : bool = true) -> int:
	var cell = -1
	for c in range(len(cells)-1, -1, -1):
		if cells[c] == null:
			cell = c
	if cell == -1:
		Dialoging.play_dialog("res://Game/Dialogs/SystemDialogs.dialogue", "item_noplace", false, "item_noplace")
		return -1
	
	cells[cell] = item
	if play_dialog:
		Dialoging.play_dialog("res://Game/Dialogs/SystemDialogs.dialogue", "item_added", false, "item_added")
	Tasking.update_task(Tasking.TaskUpdate.TYPE_ITEM_COLLECTED, {"item": item})
	return cell


func pull_item(index : int) -> BaseItem:
	if !(index in range(0, amount)):
		return null
	
	var pulled = cells[index]
	cells[index] = null
	return pulled


func get_item(index : int) -> BaseItem:
	if !(index in range(0, amount)):
		return null
	return cells[index]


func get_item_index_by_property(property : String, value : String) -> int:
	for i in range(cells.size()):
		if cells[i]:
			if cells[i].get(property) == value:
				return i
	
	return -1


func prepare_save() -> Dictionary:
	var dict : Dictionary = {
		"amount": amount,
		"cells": []
	}
	for c in cells:
		if c is BaseItem:
			dict["cells"].append(inst_to_dict(c))
		else:
			dict["cells"].append(null)
	
	# print("\n\n--- Inventory prepared for saving: {0}".format([dict]))
	return dict


func reset():
	amount = 0
	cells = []


func load_from_dict(dict : Dictionary):
	reset()
	
	amount = dict.get("amount", 0)
	var c = dict.get("cells", [])
	for i in c:
		if i is Dictionary:
			if !("@path" in i):
				cells.append(null)
				push_error("Failed to load corrupted inventory item {0}".format([i]))
				continue
			cells.append(dict_to_inst(i))
		else:
			cells.append(null)
	
	if amount == 0:
		amount = cells.size()
