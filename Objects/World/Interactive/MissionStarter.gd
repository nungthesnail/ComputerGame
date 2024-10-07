extends Area2D


@export var active : bool = true
@export var hint_text : String = "Нажмите [E] чтобы начать задание"
@export var custom_task : String = ""


func interact():
	if custom_task:
		GameProgress.request_task(custom_task)
	else:
		GameProgress.request_task(GameProgress.get_next_task())


func get_hint():
	return hint_text


func _process(delta):
	if Tasking.current_task:
		active = false
	else:
		active = true
	
	monitoring = active
	monitorable = active
	$Light.enabled = active
