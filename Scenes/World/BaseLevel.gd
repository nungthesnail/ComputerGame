extends CanvasModulate
class_name BaseLevel


@export var level_name : String = ""
var spawns : Dictionary = {}


func _init():
	# ObjectRefs.level = self
	# GameState.world_state.level = level_name
	pass


func _ready():
	ObjectRefs.level = self
	GameState.world_state.level = level_name
	spawns.merge(ObjectRefs.level_player_spawns)


func add_player_spawn(spawn_name : String, ref : Node2D):
	spawns[spawn_name] = ref


func spawn_player(spawn_name : String):
	if !(spawn_name in spawns.keys()):
		push_error("This spawn doesn\'t exist")
		return
	spawns[spawn_name].prepare()
	
	var player = load("res://Objects/Player/Player.tscn").instantiate()
	add_child(player)
	spawns[spawn_name].position_player(player)
	
	var camera = GameCamera.new()
	camera.global_position = Vector2(-1000, -1000)
	add_child(camera)
	camera.target = player
	camera.follow_target = true
	player.get_node("RemotePos").remote_path = player.get_node("RemotePos").get_path_to(camera)
	player.get_node("RemotePos").target = player.get_node("RemotePos").get_path_to(camera)


func get_mission_objects_root():
	pass


func get_npc_root():
	pass


func interiors_root():
	pass
