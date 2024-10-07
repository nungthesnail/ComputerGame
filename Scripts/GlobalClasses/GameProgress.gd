extends Node


class ProgressTask:
	var task_name : String = "" :
		get:
			return task_name
	
	var completed : bool = false :
		set(val):
			completed = val
		get:
			return completed
	
	var resource_path : String = "" :
		get:
			return resource_path
	
	var next_task : String = ""
	
	func _init(_name, _resource_path, _next_task = "", _completed = false):
		task_name = _name
		resource_path = _resource_path
		next_task = _next_task
		completed = _completed
	
	static func from(source : Dictionary):
		return ProgressTask.new(source.get("name", ""), source.get("resource", ""), source.get("next", ""))


const default_task : String = "Introduction"
var main_tasks : Array[ProgressTask] = []
var virgin : bool = false
@onready var messenger_data = load("res://Scripts/GlobalClasses/Mechanics/MessengerData.gd").new()


func init_progress():
	var tasks = JSON.parse_string(FileAccess.get_file_as_string("res://Game/Missions/Missions.json"))
	for i in tasks:
		main_tasks.append(ProgressTask.from(i))


func _ready():
	pass


func game_exists():
	return FileManager.file_exists("saves/save.data")


func get_task(task_name : String):
	for task in main_tasks:
		if task.task_name == task_name:
			return task
	return null


func start_default_task():
	var new_task = get_task(default_task)
	if new_task:
		Tasking.load_task(new_task.resource_path)


func start_next_task():
	var old_task = get_task(GameState.progress_state.last_completed_task)
	var new_task = null
	
	if old_task:
		new_task = get_task(old_task.next_task)
		if new_task:
			Tasking.load_task(new_task.resource_path)
		else:
			start_default_task()
	else:
		start_default_task()
	
	if new_task:
		print("Task {0} loaded".format([new_task.task_name]))
	
	GameState.progress_state.requesting_task = false


func start_requested_task():
	var new_task = get_task(GameState.progress_state.requesting_task_name)
	if new_task:
		Tasking.load_task(new_task.resource_path)
		print("Task {0} loaded".format([new_task.task_name]))
	else:
		push_error("Can\'t load requested task \"{0}\"".format([GameState.progress_state.requesting_task_name]))
	GameState.progress_state.requesting_task = false


func request_task(task_name):
	GameState.progress_state.requesting_task = true
	GameState.progress_state.requesting_task_name = task_name


func get_next_task():
	var prev_task = get_task(GameState.progress_state.last_completed_task)
	if prev_task:
		return prev_task.next_task
	return ""


func request_new_task():
	GameState.progress_state.requesting_task = true


func complete_task(task_name):
	var task = get_task(task_name)
	if task:
		task.completed = true
		GameState.progress_state.last_completed_task = task_name


func _process(delta):
	if GameState.progress_state.requesting_task && Tasking.current_task == null:
		start_requested_task()
	
	# if Input.is_action_just_pressed("request_task"):
	# 	request_new_task()
	# if Input.is_action_just_pressed("ui_undo"):
	# 	save_game()


func prepare_save() -> Dictionary:
	var dict : Dictionary = {
		"last_completed": GameState.progress_state.last_completed_task,
		"tasks": []
	}
	for t in main_tasks:
		dict["tasks"].append(inst_to_dict(t))
		
	# print("\n\n--- Progress prepared for saving: {0}".format([dict]))
	return dict


func reset():
	GameState.progress_state.last_completed_task = ""
	virgin = false
	for t in main_tasks:
		t.completed = false


func load_from_dict(dict : Dictionary):
	reset()
	
	GameState.progress_state.last_completed_task = dict.get("last_completed", "")
	var t = dict.get("tasks", [])
	for i in range(min(main_tasks.size(), t.size())):
		if t[i]["task_name"] == main_tasks[i].task_name:
			main_tasks[i].completed = t[i]["completed"]


func save_game():
	var data : Dictionary = {
		"dev": "1",
		"virgin": virgin,
		"inventory": Inventory.prepare_save(),
		"messenger": messenger_data.prepare_save(),
		"game_state": GameState.prepare_save(),
		"progress": prepare_save()
	}
	
	# print("\n\n--- All prepared for saving: {0}".format([data]))
	print("Game saved")
	FileManager.save_file("saves/save.data", JSON.stringify(data), false)


func load_game():
	if !game_exists():
		return FAILED
	
	var data = JSON.parse_string(FileManager.load_file("saves/save.data", false))
	if !(data is Dictionary):
		push_error("Trying to load a corrupted save file!")
		return FAILED
	
	GameState.load_from_dict(data.get("game_state", {}))
	Inventory.load_from_dict(data.get("inventory", {}))
	messenger_data.load_from_dict(data.get("messenger", {}))
	load_from_dict(data.get("progress", {}))
	virgin = data.get("virgin", false)
	
	print("Game loaded")
	return OK


func new_game():
	var virgin_data = JSON.parse_string(
		FileAccess.get_file_as_string("res://Resources/System/VirginSave.json"))
	FileManager.save_file("saves/save.data", JSON.stringify(virgin_data), false)
	print("New game started")
