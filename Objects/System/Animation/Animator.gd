extends AnimationPlayer
class_name Animator


var prev_animation : String = ""
var prev_process_animation : String = ""


func animation_changed(_anim_name):
	Tasking.update_task(Tasking.TaskUpdate.TYPE_ANIM_END, {"name": prev_animation})
	if current_animation:
		Tasking.update_task(Tasking.TaskUpdate.TYPE_ANIM_START, {"name": current_animation})


func update_task(data):
	Tasking.update_task(Tasking.TaskUpdate.TYPE_ANIM_EVENT, data)


func _ready():
	# current_animation_changed.connect(animation_changed)
	pass


func _process(_delta):
	if current_animation != prev_process_animation:
		prev_animation = prev_process_animation
		animation_changed(current_animation)
	prev_process_animation = current_animation
