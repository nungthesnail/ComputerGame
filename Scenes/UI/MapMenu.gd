extends Control


func _ready():
	update_map_points()


func convert_coords(world_coords : Vector2):
	return world_coords * (Vector2(660, 470) / Vector2(ObjectRefs.level.get_level_rect())) - Vector2(15,15)


func update_map_points():
	for mp in GameState.world_state.map_points:
		var mp_obj = load("res://Scenes/UI/MapPoint/MapPoint.tscn").instantiate()
		$MarginContainer/Points.add_child(mp_obj)
		mp_obj.position = convert_coords(mp.position)
		mp_obj.scale = mp.scale
