extends Node


enum {
	STATE_MAIN_MUSIC = 0,
	STATE_SEC_MUSIC = 1
}
var state : int = STATE_MAIN_MUSIC
var main_track : String = ""
var sec_track : String = ""


func play_main_music(path : String):
	if !ResourceLoader.exists(path):
		push_error("Music file %s doesn\'t exists" % [path])
		return
	
	main_track = path
	if state == STATE_MAIN_MUSIC:
		$AnimationPlayer.play("main_music")


func play_sec_music(path : String):
	if !ResourceLoader.exists(path):
		push_error("Music file %s doesn\'t exists" % [path])
		return
	
	sec_track = path
	state = STATE_SEC_MUSIC
	$AnimationPlayer.play("sec_music")


func stop_sec_music():
	state = STATE_MAIN_MUSIC
	$AnimationPlayer.play("stop_sec")


func change_main():
	$MainPlayer.stop()
	$MainPlayer.stream = load(main_track)
	$MainPlayer.play()


func change_sec():
	$SecondaryPlayer.stop()
	$SecondaryPlayer.stream = load(sec_track)
	$SecondaryPlayer.play()


func stop_all():
	$AnimationPlayer.play("stop_all")


func change2main():
	$SecondaryPlayer.stop()
	$MainPlayer.play()
