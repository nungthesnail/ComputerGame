extends Node


class PlayerState:
	var hp : int = 10
	var max_hp : int = 10
	var default_speed : float = 150.0
	var active : bool = true


class GameplayState:
	var dialoging : bool = false
	var cutscene : bool = false
	var can_save : bool = true

class ProgressState:
	var requesting_task : bool = false
	var requesting_task_name : String = ""
	var last_completed_task : String = ""


class WorldState:
	class MapPoint:
		var position : Vector2 = Vector2.ZERO
		var scale : Vector2 = Vector2(0.3, 0.3)
		var id : String = ""
		
		func _init(id = "", pos = Vector2.ZERO, scl = Vector2(0.3, 0.3)):
			position = pos
			scale = scl
	
	var level : String = ""
	var spawn : String = ""
	var map_points : Array[MapPoint] = [MapPoint.new("test1", Vector2(1104, 485), Vector2(1, 1))]


enum States {
	STATE_FREE = 0,
	STATE_COMPUTER = 1,
	STATE_CUTSCENE = 2
}


var player_state : PlayerState = PlayerState.new()
var gameplay_state : GameplayState = GameplayState.new()
var world_state : WorldState = WorldState.new()
var progress_state : ProgressState = ProgressState.new()
var current_computer : Computer = null
@onready var inventory = Inventory
@onready var tasking = Tasking

var state : States = States.STATE_FREE


func _process(delta):
	if Input.is_action_just_pressed("ui_page_up"):
		print(tasking.current_task)


func start_computer(id : String):
	ObjectRefs.ui_root.start_computer(id)
	player_state.active = false


func stop_computer():
	if !current_computer:
		return
	
	current_computer = null
	player_state.active = true


func reset():
	player_state = PlayerState.new()
	gameplay_state = GameplayState.new()
	world_state = WorldState.new()
	progress_state = ProgressState.new()


func load_from_dict(dict : Dictionary):
	reset()
	var ps = dict.get("player", {})
	var ws = dict.get("world", {})
	
	player_state.default_speed = ps.get("speed", 150)
	player_state.max_hp = ps.get("max_hp", 10)
	player_state.hp = ps.get("hp", 10)
	
	world_state.level = ws.get("level", "Desert")
	world_state.spawn = ws.get("spawn", "player_house")


func prepare_save() -> Dictionary:
	var dict : Dictionary = {
		"player": {
			"speed": player_state.default_speed,
			"hp": player_state.hp,
			"max_hp": player_state.max_hp
		},
		"world": {
			"level": world_state.level,
			"spawn": world_state.spawn
		}
	}
	return dict
