extends Node


var current_dialog : Node = null
var current_dialog_name : String = ""
var cutscene_dialog : bool = false


func play_dialog(path : String, title : String, cutscene : bool = true, idname : String = ""):
	if GameState.gameplay_state.dialoging:
		return
	if cutscene:
		GameState.player_state.active = false
		cutscene_dialog = true
	
	current_dialog = ObjectRefs.ui_root.get_ui_gameplay().play_dialog(path, title)
	current_dialog_name = idname
	GameState.gameplay_state.dialoging = true
	Tasking.update_task(Tasking.TaskUpdate.TYPE_DIALOG_START, {"name": idname})


func end_dialog():
	GameState.gameplay_state.dialoging = false
	if cutscene_dialog:
		GameState.player_state.active = true
		cutscene_dialog = false
	Tasking.update_task(Tasking.TaskUpdate.TYPE_DIALOG_END, {"name": current_dialog_name})
	current_dialog = null
	current_dialog_name = ""


func _process(delta):
	if !is_instance_valid(current_dialog) && GameState.gameplay_state.dialoging == true:
		end_dialog()
