extends Tasking.Task


"""
	Сценарий задания:
	0. Вступление игры
	1. Обучение ходьбе
	2. Выход на улицу
	3. Встреча с Миширану
	4. Доставка уведомления
	5. Включение компьютера
	6. Прочтение уведомления в blobtalk
	7. Запуск netwalker
	8. Получение координат
	9. Встреча с Миширану
"""


var blobtalk_data = {}
var step : int = 0
var ui_cover : Control = null
var time : float = 0.0

var task_objects : Array[Node] = []


func prepare_mission():
	blobtalk_data = JSON.parse_string(FileAccess.get_file_as_string("res://Game/Missions/m01_Introduction/BlobTalkData.json"))
	prepare_world()


func start(data = null):
	# Введение перед историей игры
	await prepare_mission()
	GameState.gameplay_state.can_save = false
	task_name = "Introduction"
	AudioMaster.play_sec_music("res://Audio/Music/Introduction/Intro.ogg")
	ui_cover = ObjectRefs.ui_root.add_cover("res://Scenes/UI/StoryBackground.tscn", "StoryBackground")
	Dialoging.play_dialog("res://Game/Missions/m01_Introduction/Intro_WorldStory.dialogue", "intro_1", true, "intro_1")


func update(upd, data = null):
	if step == 0 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "intro_1":
		# Обучение ходьбе
		ObjectRefs.ui_root.delete_cover("StoryBackground")
		AudioMaster.play_sec_music("res://Audio/Music/LevelDesert/DesertAmbient.ogg")
		ObjectRefs.player.get_hint_label().set_primary_text("Нажимайте [W][A][S][D] чтобы ходить")
		step = 1
	
	if step == 2 && upd == Tasking.TaskUpdate.TYPE_TELEPORTED && data.get("destination") == "open_world":
		# Игрок вышел на улицу
		Dialoging.play_dialog("res://Game/Missions/m01_Introduction/Intro_Tutorial1.dialogue", "tutorial_2", true, "tutorial_2")
		step = 3
	
	if step == 3 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "mishiranu_1":
		step = 4
		time = 5.0
	
	if step == 5 && upd == Tasking.TaskUpdate.TYPE_COMPUTER_START && data.get("name") == "player_pc":
		step = 6
		ObjectRefs.ui_root.get_ui_computer().set_help_text(blobtalk_data["comp_task1"])
		GameState.current_computer.run_program("res://Game/Missions/m01_Introduction/ComputerTask.tres")
		
	
	if step == 6 && upd == Tasking.TaskUpdate.TYPE_COMPUTER_EVENT && data.get("chat") == "Миширану":
		step = 7
		ObjectRefs.ui_root.get_ui_computer().set_help_text(blobtalk_data["comp_task2"])
	
	if step == 7 && upd == Tasking.TaskUpdate.TYPE_COMPUTER_EVENT && data.get("program") == "netwalker":
		step = 8
		ObjectRefs.ui_root.get_ui_computer().set_help_text(blobtalk_data["comp_task3"])
	
	if step == 8 && upd == Tasking.TaskUpdate.TYPE_COMPUTER_EVENT && data.get("response") == "correct":
		step = 9
		ObjectRefs.ui_root.get_ui_computer().set_help_text(blobtalk_data["comp_task4"])
		GameProgress.messenger_data.send_message("Миширану", blobtalk_data["9"])
	
	if step == 9 && upd == Tasking.TaskUpdate.TYPE_COMPUTER_EVENT && data.get("chat") == "Миширану":
		step = 10
		ObjectRefs.ui_root.get_ui_computer().set_help_text(blobtalk_data["comp_task5"])
	
	if step == 10 && upd == Tasking.TaskUpdate.TYPE_COMPUTER_SHUTDOWN:
		step = 11
		Dialoging.play_dialog("res://Game/Missions/m01_Introduction/Intro_Tutorial1.dialogue", "comp_off", true, "comp_off")
	
	if step == 11 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "mishiranu_2":
		step = 12
		time = 5.0
	
	if step == 13 && upd == Tasking.TaskUpdate.TYPE_NONE && data.get("data") == "started":
		step = 14
		Dialoging.play_dialog("res://Game/Missions/m01_Introduction/Intro_Tutorial1.dialogue", "completed", true, "completed")
	
	if step == 14 && upd == Tasking.TaskUpdate.TYPE_DIALOG_END && data.get("name") == "completed":
		ObjectRefs.ui_root.delete_cover("EndBackground")
		end_task()


func process(delta = null):
	if time > 0.0:
		time -= delta
	
	if step == 1 && (Input.is_action_pressed("up")
		|| Input.is_action_pressed("down")
		|| Input.is_action_pressed("right")
		|| Input.is_action_pressed("left")):
			# Когда игрок прошелся
			step = 2
			ObjectRefs.player.get_hint_label().clear_primary_text()
			Dialoging.play_dialog("res://Game/Missions/m01_Introduction/Intro_Tutorial1.dialogue", "tutorial_1", true, "tutorial_1")
	
	if step == 4 && time <= 0.0:
		GameProgress.messenger_data.send_message("Миширану", blobtalk_data["4"], "res://Sprites/Misc/Avatars/MishiranuAvatar.png")
		GameProgress.messenger_data.notificate()
		step = 5
	
	if step == 12 && time <= 0.0:
		ui_cover = ObjectRefs.ui_root.add_cover("res://Scenes/UI/StoryBackground.tscn", "EndBackground")
		ui_cover.play_animation("start")
		step = 13


func end_task():
	for o in task_objects:
		o.queue_free()
	GameState.gameplay_state.can_save = true
	GameProgress.complete_task(task_name)
	GameProgress.save_game()
	end()


func prepare_world():
	var mishiranu = load("res://Objects/NPC/Friends/Mishiranu/Mishiranu.tscn").instantiate()
	mishiranu.global_position = Vector2(884, 483)
	ObjectRefs.level.get_npc_root().add_child(mishiranu)
	task_objects.append(mishiranu)
