extends Tasking.Task


var step : int = 0
var timer : float = 0.0
var ui_cover : Control = null
var blobtalk_data = JSON.parse_string(
	FileAccess.get_file_as_string("res://Game/Missions/m03_MoonProcessing/BlobTalkData.json"))


func start(data = null):
	await prepare_mission()
	timer = 2.0


func update(upd, data = null):
	if step == 1 && upd == Tasking.TaskUpdate.TYPE_COMPUTER_START && data.get("name") == "player_pc":
		ObjectRefs.ui_root.get_ui_computer().set_help_text(blobtalk_data["comp1"])
		GameState.current_computer.run_program("res://Game/Missions/m03_MoonProcessing/ComputerTask.tres")
	
	if step == 1 && upd == Tasking.TaskUpdate.TYPE_COMPUTER_EVENT && data.get("chat") == "Миширану":
		step = 2
		ObjectRefs.ui_root.get_ui_computer().set_help_text(blobtalk_data["comp2"])
	
	if step == 2 && upd == Tasking.TaskUpdate.TYPE_COMPUTER_EVENT && data.get("program") == "luanvil":
		step = 3
		ObjectRefs.ui_root.get_ui_computer().set_help_text(blobtalk_data["comp3"])
	
	if step == 3 && upd == Tasking.TaskUpdate.TYPE_LUA_EXECUTED && data.get("tests_passed"):
		step = 4
		GameProgress.messenger_data.send_message("Миширану", blobtalk_data["4"])
		ObjectRefs.ui_root.get_ui_computer().set_help_text(blobtalk_data["comp4"])
	
	if step == 4 && upd == Tasking.TaskUpdate.TYPE_COMPUTER_EVENT && data.get("chat") == "Миширану":
		step = 5
		ObjectRefs.ui_root.get_ui_computer().set_help_text(blobtalk_data["comp5"])
	
	if step == 5 && upd == Tasking.TaskUpdate.TYPE_COMPUTER_SHUTDOWN:
		step = 6
		timer = 5.0
	
	if step == 7 && upd == Tasking.TaskUpdate.TYPE_NONE && data.get("data") == "started":
		step = 8
		Dialoging.play_dialog("res://Game/Missions/m03_MoonProcessing/MoonProcessingDialogs.dialogue", "completed", true, "completed")
	
	if step == 8 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "completed":
		ObjectRefs.ui_root.delete_cover("EndBackground")
		end_task()


func process(delta = 0.0):
	if timer > 0.0:
		timer -= delta
	
	if step == 0 && timer <= 0.0:
		if Dialoging.current_dialog:
			timer = 5.0
		else:
			step = 1
			GameProgress.messenger_data.send_message("Миширану", blobtalk_data["1"])
			GameProgress.messenger_data.notificate()
			# Dialoging.play_dialog("res://Game/Dialogs/SystemDialogs.dialogue", "blobtalk_notification", false)
	
	if step == 6 && timer <= 0.0:
		ui_cover = ObjectRefs.ui_root.add_cover("res://Scenes/UI/StoryBackground.tscn", "EndBackground")
		ui_cover.play_animation("start")
		step = 7


func prepare_mission():
	task_name = "MoonProcessing"
	GameState.gameplay_state.can_save = false


func end_task():
	GameState.gameplay_state.can_save = true
	GameProgress.complete_task(task_name)
	GameProgress.save_game()
	end()


func get_lua_tests() -> Array[LuaInterpreter.TestData]:
	return [
		LuaInterpreter.TestData.new(["5", "7"], 7),
		LuaInterpreter.TestData.new(["58", "24"], 58),
		LuaInterpreter.TestData.new(["11", "0"], 11),
		LuaInterpreter.TestData.new(["100000", "500000"], 500000)
	]
