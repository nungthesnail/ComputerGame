extends Marker2D


@export var spawn_name : String = ""


func _ready():
	ObjectRefs.level_player_spawns[spawn_name] = self


func prepare():
	pass


func position_player(player : Node2D):
	player.global_position = global_position
