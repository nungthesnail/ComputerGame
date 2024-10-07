extends Object
class_name BaseItem


var item_id : String = ""
var item_name : String = ""
var description : String = ""
var icon_path : String = ""
var icon_region : Rect2
var locked : bool = false


func get_json():
	return {
		"item_id": item_id,
		"item_name": item_name,
		"description": description,
		"icon_path": icon_path,
		"locked": locked,
		"icon_region": icon_region
	}
