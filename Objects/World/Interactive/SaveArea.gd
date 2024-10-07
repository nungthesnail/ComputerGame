
extends Area2D


@export var active : bool = true
@export var hint_text : String = "Нажмите [E] чтобы сохраниться"


func interact():
	GameProgress.save_game()
	Dialoging.play_dialog("res://Game/Dialogs/SystemDialogs.dialogue", "game_saved", false, "game_saved")


func get_hint():
	return hint_text


func _process(delta):
	active = GameState.gameplay_state.can_save
	monitoring = active
	monitorable = active
	$Light.enabled = active
