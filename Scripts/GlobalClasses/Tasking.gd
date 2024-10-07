extends Node


class Task extends Resource:
	var task_name : String = ""
	
	func start(data=null):
		pass
	
	func process(data=null):
		pass
	
	func update(upd, data=null):
		pass
	
	func end(data=null):
		dispose()
	
	func fail(data=null):
		pass
	
	func dispose():
		Gameplay.game_state.tasking.task_disposed(self)
	
	func permit_end():
		return true
	
	func force_end(data=null):
		end(data)


class TaskUpdate:
	enum {
		TYPE_NONE = 0,
		TYPE_STEP_PASS = 1,
		TYPE_ITEM_COLLECTED = 2,
		TYPE_TIMEOUT = 3,
		TYPE_TELEPORTED = 4,
		TYPE_COMPUTER_START = 5,
		TYPE_COMPUTER_SHUTDOWN = 6,
		TYPE_COMPUTER_EVENT = 7,
		TYPE_DIALOG_START = 8,
		TYPE_DIALOG_END = 9,
		TYPE_AREA_REACHED = 10,
		TYPE_AREA_LEAVED = 11,
		TYPE_ANIM_START = 12,
		TYPE_ANIM_EVENT = 13,
		TYPE_ANIM_END = 14,
		TYPE_LUA_EXECUTED = 15
	}
	
	var type : int = TYPE_NONE
	var message : String = ""


func update_task(upd, data = null):
	if !current_task:
		return
	
	current_task.update(upd, data)


func start_task(task : Task, data = null):
	if current_task:
		if !current_task.permit_end():
			return
		current_task.end()
	
	current_task = task
	task.start(data)


func load_task(path : String, data = null):
	if ResourceLoader.exists(path):
		start_task(load(path).new(), data)
	else:
		push_error("Task path %s doesn\'t exists" % [path])


func end_task(data=null):
	if !current_task:
		return
	if !current_task.permit_end():
		return -1
	
	current_task.end()


func task_disposed(task):
	current_task = null


var current_task : Task = null


func _process(delta):
	if current_task:
		current_task.process(delta)
