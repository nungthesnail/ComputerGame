extends BaseNPC


func _process(delta):
	if Tasking.current_task:
		if has_method(Tasking.current_task.task_name):
			call(Tasking.current_task.task_name, delta)
	super._process(delta)


func Quicksand(delta):
	active = Tasking.current_task.step >= 6


func RaiseTheAlarm(delta):
	if Tasking.current_task.step == 6:
		global_position = $"../Path/PathFollow".global_position
