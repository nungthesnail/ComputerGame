extends Area2D


@export var computer_name : String = ""
@export var hint_text : String = "Нажмите [E] чтобы включить компьютер"


func get_hint():
	return hint_text


func interact():
	$AnimationPlayer.play("interact")
	ObjectRefs.ui_root.get_ui_gameplay().play_animation("transition")


func animation_middle():
	Gameplay.start_computer(computer_name)


func animation_end():
	Tasking.update_task(Tasking.TaskUpdate.TYPE_COMPUTER_START, {"name": computer_name})
