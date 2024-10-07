extends Area2D


@export var area_name : String = ""


func body_entered(body):
	if body.is_in_group("player"):
		Tasking.update_task(Tasking.TaskUpdate.TYPE_AREA_REACHED, {"name": area_name})


func body_exited(body):
	if body.is_in_group("player"):
		Tasking.update_task(Tasking.TaskUpdate.TYPE_AREA_LEAVED, {"name": area_name})
