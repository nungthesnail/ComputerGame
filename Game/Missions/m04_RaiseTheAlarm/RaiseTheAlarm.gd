extends Tasking.Task


var step : int = 0
var timer : float = 0.0
var ui_cover : Control = null
var faint_cover : Control = null
var ending_cover : Control = null
var task_objects : Array = []
var blobtalk_data = JSON.parse_string(
	FileAccess.get_file_as_string("res://Game/Missions/m03_MoonProcessing/BlobTalkData.json"))


func start(data = null):
	prepare_mission()
	timer = 2.0


func update(upd, data = null):
	if step == 1 && upd == Tasking.TaskUpdate.TYPE_TELEPORTED && data.get("destination") == "open_world":
		Dialoging.play_dialog("res://Game/Missions/m04_RaiseTheAlarm/RaiseTheAlarmDialogs.dialogue", "talk_to_mishiranu", true, "talk_to_mishiranu")
	
	if step == 1 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "mishiranu1":
		GameState.player_state.active = false
		task_objects[0].get_node("AnimationPlayer").play("mishiranu_gone1")
		timer = 3.5
		step = 2
	
	if step == 3 && upd == Tasking.TaskUpdate.TYPE_ITEM_COLLECTED && data.get("item").item_id == "beacon_part":
		step = 4
		Dialoging.play_dialog("res://Game/Missions/m04_RaiseTheAlarm/RaiseTheAlarmDialogs.dialogue", "part1_gotten", true, "part1_gotten")
	elif step == 4 && upd == Tasking.TaskUpdate.TYPE_ITEM_COLLECTED && data.get("item").item_id == "beacon_part":
		step = 5
		Dialoging.play_dialog("res://Game/Missions/m04_RaiseTheAlarm/RaiseTheAlarmDialogs.dialogue", "part2_gotten", true, "part2_gotten")
		task_objects[0].get_node("AnimationPlayer").play("mishiranu2")
	
	if step == 5 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "mishiranu2":
		step = 6
		
		# Удаление запчастей из инвентаря
		var cell_id = Inventory.get_item_index_by_property("item_id", "beacon_part")
		if cell_id + 1:
			Inventory.pull_item(cell_id)
		cell_id = Inventory.get_item_index_by_property("item_id", "beacon_part")
		if cell_id + 1:
			Inventory.pull_item(cell_id)
		
		Dialoging.play_dialog("res://Game/Missions/m04_RaiseTheAlarm/RaiseTheAlarmDialogs.dialogue", "follow_mishiranu", false, "follow_mishiranu")
		task_objects[0].get_node("AnimationPlayer").play("walk")
	
	if step == 6 && upd == Tasking.TaskUpdate.TYPE_ANIM_END && data.get("name") == "walk":
		Dialoging.play_dialog("res://Game/Missions/m04_RaiseTheAlarm/RaiseTheAlarmDialogs.dialogue", "enter_hostel", false, "enter_hostel")
	
	# Начало катсцены в хостеле
	
	if step == 6 && upd == Tasking.TaskUpdate.TYPE_TELEPORTED && data.get("destination") == "hostel_room_desert":
		step = 7
		GameState.player_state.active = false
		ObjectRefs.player.hide()
		ObjectRefs.camera.follow_target = false
		ObjectRefs.camera.fixed_point = task_objects[0].get_node("InteriorCamPosition")
		GameState.gameplay_state.cutscene = true
		task_objects[0].get_node("AnimationPlayer").play("hostel1")
	
	if step == 7 && upd == Tasking.TaskUpdate.TYPE_ANIM_END && data.get("name") == "hostel1":
		Dialoging.play_dialog("res://Game/Missions/m04_RaiseTheAlarm/RaiseTheAlarmDialogs.dialogue", "hostel1", false, "hostel1")
	if step == 7 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "hostel1":
		task_objects[0].get_node("AnimationPlayer").play("hostel2")
	
	if step == 7 && upd == Tasking.TaskUpdate.TYPE_ANIM_END && data.get("name") == "hostel2":
		Dialoging.play_dialog("res://Game/Missions/m04_RaiseTheAlarm/RaiseTheAlarmDialogs.dialogue", "hostel2", false, "hostel2")
	if step == 7 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "hostel2":
		task_objects[0].get_node("AnimationPlayer").play("hostel3")
	
	if step == 7 && upd == Tasking.TaskUpdate.TYPE_ANIM_END && data.get("name") == "hostel3":
		Dialoging.play_dialog("res://Game/Missions/m04_RaiseTheAlarm/RaiseTheAlarmDialogs.dialogue", "hostel3", false, "hostel3")
	if step == 7 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "hostel3":
		task_objects[0].get_node("AnimationPlayer").play("hostel4")
	
	if step == 7 && upd == Tasking.TaskUpdate.TYPE_ANIM_END && data.get("name") == "revolver_main":
		task_objects[0].get_node("AnimationPlayer").delete_cover()
		faint_cover = ObjectRefs.ui_root.add_cover("res://Game/Missions/m04_RaiseTheAlarm/FaintCover.tscn", "faint_cover")
		faint_cover.play_animation("faint_begin")
	
	if step == 7 && upd == Tasking.TaskUpdate.TYPE_ANIM_END && data.get("name") == "hostel4":
		Dialoging.play_dialog("res://Game/Missions/m04_RaiseTheAlarm/RaiseTheAlarmDialogs.dialogue", "hostel4", false, "hostel4")
	if step == 7 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "hostel4":
		task_objects[0].get_node("AnimationPlayer").play("hostel5")
	
	if step == 7 && upd == Tasking.TaskUpdate.TYPE_ANIM_EVENT && data.get("event") == "faint_progress":
		faint_cover.play_animation("faint_progress")
	
	if step == 7 && upd == Tasking.TaskUpdate.TYPE_ANIM_END && data.get("name") == "faint_progress":
		step = 8
		ObjectRefs.ui_root.delete_cover("faint_cover")
		GameState.gameplay_state.cutscene = false
		ObjectRefs.camera.follow_target = true
		GameState.world_state.level = "Desert"
		GameState.world_state.spawn = "player_house"
		ending_cover = ObjectRefs.ui_root.add_cover("res://Scenes/UI/StoryBackground.tscn", "ending")
		ending_cover.play_animation("begun")
		Dialoging.play_dialog("res://Game/Missions/m04_RaiseTheAlarm/RaiseTheAlarmDialogs.dialogue", "completed", false, "completed")
		Global.loading_type = Global.LOADING_TYPE_LEVEL
		ObjectRefs.game_root.reload()
	
	if step == 8 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "completed":
		ObjectRefs.ui_root.delete_cover("ending")
		GameState.player_state.active = true
		ObjectRefs.player.show()
		end_task()
	# Конец катсцены в хостеле


func process(delta = null):
	if timer > 0.0:
		timer -= delta
	
	if step == 0 && timer <= 0.0:
		step = 1
		Dialoging.play_dialog("res://Game/Missions/m04_RaiseTheAlarm/RaiseTheAlarmDialogs.dialogue", "come_to_street", true, "come_to_street")
	
	if step == 2 && timer <= 0.0:
		step = 3
		Dialoging.play_dialog("res://Game/Missions/m04_RaiseTheAlarm/RaiseTheAlarmDialogs.dialogue", "task_main", true, "task_main")
	
	if is_instance_valid(task_objects[0]):
		if task_objects[0].get_node_or_null("BeaconPart1"):
			task_objects[0].get_node("BeaconPart1").active = step >= 3
		if task_objects[0].get_node_or_null("BeaconPart2"):
			task_objects[0].get_node("BeaconPart2").active = step >= 3


func prepare_mission():
	task_name = "RaiseTheAlarm"
	GameState.gameplay_state.can_save = false
	prepare_world()


func prepare_world():
	var obj = load("res://Game/Missions/m04_RaiseTheAlarm/RaiseTheAlarmObjects.tscn").instantiate()
	ObjectRefs.level.get_mission_objects_root().add_child(obj)
	task_objects.push_back(obj)


func end_task():
	for o in task_objects:
		if is_instance_valid(o):
			o.queue_free()
	GameState.gameplay_state.can_save = true
	GameProgress.complete_task(task_name)
	GameProgress.save_game()
	end()
