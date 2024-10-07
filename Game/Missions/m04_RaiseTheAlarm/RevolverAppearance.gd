extends Control


func play_animation(anim : String):
	$AnimationPlayer.play(anim)


func update_task(data = null):
	Tasking.update_task(Tasking.TaskUpdate.TYPE_ANIM_EVENT, data)


func end(args = null):
	$AnimationPlayer.play("end")
