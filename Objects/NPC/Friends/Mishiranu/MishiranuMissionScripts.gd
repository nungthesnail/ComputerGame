extends Resource


var tags : Array[String] = []


func Introduction():
	if Tasking.current_task.step == 3:
		Dialoging.play_dialog("res://Game/Missions/m01_Introduction/Intro_Tutorial1.dialogue", "mishiranu_1", true, "mishiranu_1")
	elif Tasking.current_task.step == 11:
		Dialoging.play_dialog("res://Game/Missions/m01_Introduction/Intro_Tutorial1.dialogue", "mishiranu_2", true, "mishiranu_2")
	else:
		Dialoging.play_dialog("res://Game/Missions/m01_Introduction/Intro_Tutorial1.dialogue", "mishiranu_idle", true, "mishiranu_idle")


func Quicksand():
	if Tasking.current_task.step == 6:
		Dialoging.play_dialog("res://Game/Missions/m02_Quicksand/QuicksandCharactersDialogs.dialogue", "mishiranu", true, "mishiranu")

func RaiseTheAlarm():
	if Tasking.current_task.step == 1:
		Dialoging.play_dialog("res://Game/Missions/m04_RaiseTheAlarm/RaiseTheAlarmDialogs.dialogue", "mishiranu1", true, "mishiranu1")
	elif Tasking.current_task.step == 5:
		Dialoging.play_dialog("res://Game/Missions/m04_RaiseTheAlarm/RaiseTheAlarmDialogs.dialogue", "mishiranu2", true, "mishiranu2")
