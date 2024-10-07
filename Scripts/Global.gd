extends Node


enum {
	LOADING_TYPE_GAME = 0,
	LOADING_TYPE_LEVEL = 1
}
var loading_type : int = LOADING_TYPE_GAME


func _init():
	GameProgress.init_progress()
	FileManager.init_filesystem()
