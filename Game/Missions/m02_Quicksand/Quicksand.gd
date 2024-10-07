extends Tasking.Task


var step : int = 0
var timer : float = 0.0
var task_objects : Array[Node] = []
var blobtalk_data = JSON.parse_string(
	FileAccess.get_file_as_string("res://Game/Missions/m02_Quicksand/BlobTalkData.json"))
var ui_cover : Control = null


func start(data = null):
	await prepare_mission()
	timer = 5.0


func update(upd, data = null):
	if step == 1 && upd == Tasking.TaskUpdate.TYPE_AREA_REACHED && data.get("name") == "RiverVillage":
		Dialoging.play_dialog("res://Game/Missions/m02_Quicksand/QuicksandDialogs.dialogue", "v_reached", false, "v_reached")
	elif step == 1 && upd == Tasking.TaskUpdate.TYPE_AREA_LEAVED && data.get("name") == "RiverVillage":
		Dialoging.play_dialog("res://Game/Missions/m02_Quicksand/QuicksandDialogs.dialogue", "v_leaved", false, "v_leaved")
	
	if step == 1 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "friend1":
		step = 2
		Dialoging.play_dialog("res://Game/Missions/m02_Quicksand/QuicksandDialogs.dialogue", "find_aiden", false, "find_aiden")
	
	if step == 2 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "friend2":
		step = 3
		Dialoging.play_dialog("res://Game/Missions/m02_Quicksand/QuicksandDialogs.dialogue", "find_marshal", false, "find_marshal")
	
	if step == 3 && upd == Tasking.TaskUpdate.TYPE_AREA_REACHED && data.get("name") == "river_camp":
		Dialoging.play_dialog("res://Game/Missions/m02_Quicksand/QuicksandDialogs.dialogue", "c_reached", false, "c_reached")
	
	if step == 3 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "marshal":
		step = 4
		Dialoging.play_dialog("res://Game/Missions/m02_Quicksand/QuicksandDialogs.dialogue", "info_received", true, "info_received")
	
	if step == 4 && upd == Tasking.TaskUpdate.TYPE_ITEM_COLLECTED && data.get("item").item_id == "marshal_flash":
		step = 5
		Dialoging.play_dialog("res://Game/Missions/m02_Quicksand/QuicksandDialogs.dialogue", "flash_gotten", true, "flash_gotten")
		GameProgress.messenger_data.send_message("Миширану", blobtalk_data["5"])
	
	if step == 5 && upd == Tasking.TaskUpdate.TYPE_COMPUTER_SHUTDOWN && data.get("name") == "player_pc":
		step = 6
		Dialoging.play_dialog("res://Game/Missions/m02_Quicksand/QuicksandDialogs.dialogue", "meet_mishiranu", true, "meet_mishiranu")
	
	if step == 6 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "mishiranu":
		step = 7
		GameState.player_state.active = false
		var cell_id = Inventory.get_item_index_by_property("item_id", "marshal_flash")
		if cell_id + 1:
			Inventory.pull_item(cell_id)
		task_objects[0].get_node("Animator").play("mishiranu_go_away")
	
	if step == 7 && upd == Tasking.TaskUpdate.TYPE_ANIM_EVENT && data.get("event") == "mishiranu_gone":
		step = 8
		ui_cover = ObjectRefs.ui_root.add_cover("res://Scenes/UI/StoryBackground.tscn", "EndBackground")
		ui_cover.play_animation("start")
	
	if step == 8 && upd == Tasking.TaskUpdate.TYPE_NONE && data.get("data") == "started":
		Dialoging.play_dialog("res://Game/Missions/m02_Quicksand/QuicksandDialogs.dialogue", "completed", true, "completed")
	elif step == 8 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "completed":
		ObjectRefs.ui_root.delete_cover("EndBackground")
		GameState.player_state.active = true
		end_task()


func process(delta = 0.0):
	if timer > 0.0:
		timer -= delta
	
	if step == 0 && timer <= 0.0:
		if Dialoging.current_dialog:
			timer = 5.0
		else:
			step = 1
			Dialoging.play_dialog("res://Game/Missions/m02_Quicksand/QuicksandDialogs.dialogue", "intro", true, "intro")
	
	task_objects[0].get_node("Marshal").active = step >= 3
	# task_objects[0].get_node("Mishiranu").active = step >= 3
	task_objects[1].active = step >= 2 && step < 4


func prepare_mission():
	task_name = "Quicksand"
	GameState.gameplay_state.can_save = false
	prepare_world()


func prepare_world():
	var objects = load("res://Game/Missions/m02_Quicksand/QuicksandObjects.tscn").instantiate()
	ObjectRefs.level.get_mission_objects_root().add_child(objects)
	task_objects.append(objects)
	
	var aiden = load("res://Objects/NPC/Decoration/BaldBlackNpc.tscn").instantiate()
	aiden.set_name("Bald")
	aiden.tags.append("marshal_friend2")
	aiden.mission_scripts_class = load("res://Objects/NPC/Decoration/NpcMissionScriptsDesert.gd")
	ObjectRefs.level.get_interiors_root().get_node("PlayerHouse/Floor1").add_child(aiden)
	aiden.position = Vector2(70,104)
	task_objects.append(aiden)


func end_task():
	for o in task_objects:
		o.queue_free()
	GameState.gameplay_state.can_save = true
	GameProgress.complete_task(task_name)
	GameProgress.save_game()
	end()
