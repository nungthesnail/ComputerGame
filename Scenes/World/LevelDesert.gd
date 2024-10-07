extends BaseLevel


func _ready():
	super._ready()


func get_mission_objects_root():
	return $Objects/MissionObjects


func get_npc_root():
	return $Objects/NPC


func get_interiors_root():
	return $Interiors


func get_level_rect():
	return $World.get_used_rect().size * $World.tile_set.tile_size
