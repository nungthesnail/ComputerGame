extends Resource


var tags : Array[String] = []


func Quicksand():
	if "river_village" in tags && Tasking.current_task.step == 1:
		if "marshal_friend1" in tags:
			Dialoging.play_dialog("res://Game/Missions/m02_Quicksand/QuicksandCharactersDialogs.dialogue", "friend1", true, "friend1")
		else:
			Dialoging.play_dialog("res://Game/Missions/m02_Quicksand/QuicksandCharactersDialogs.dialogue", "quicksand_def", true, "quicksand_def")
	
	elif "marshal_friend2" in tags && Tasking.current_task.step == 2:
		Dialoging.play_dialog("res://Game/Missions/m02_Quicksand/QuicksandCharactersDialogs.dialogue", "friend2", true, "friend2")
	
	elif "marshal" in tags && Tasking.current_task.step == 3:
		Dialoging.play_dialog("res://Game/Missions/m02_Quicksand/QuicksandCharactersDialogs.dialogue", "marshal", true, "marshal")
	
	else:
		default_dialog()


func default_dialog():
	Dialoging.play_dialog("res://Game/Dialogs/CharacterDialogs/DesertDialogs.dialogue", "default_dialog", true, "default_dialog")
