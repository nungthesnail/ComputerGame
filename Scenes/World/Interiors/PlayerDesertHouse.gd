extends Node2D


var floor : int = 1


func stairs_entered(body):
	if body.is_in_group("player"):
		$AnimationPlayer.play("switch_floor")
		ObjectRefs.ui_root.get_ui_gameplay().play_animation("transition")
		GameState.player_state.active = false


func animation_end():
	GameState.player_state.active = true


func switch_floor_visiblity():
	floor = 1 if floor == 2 else 2
	$Floor1.visible = true if floor == 1 else false
	$Floor2.visible = true if floor == 2 else false


func switch_floor():
	switch_floor_visiblity()
	if floor == 1:
		ObjectRefs.player.global_position = $Floor1/Spawn.global_position
	else:
		ObjectRefs.player.global_position = $Floor2/Spawn.global_position
