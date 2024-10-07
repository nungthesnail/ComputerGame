extends Node


var loading_type : int = Global.LOADING_TYPE_GAME # 0 - load game, 1 - just load a level
var world_state = null


func _ready():
	ObjectRefs.game_root = self
	reload()


func reload():
	loading_type = Global.loading_type
	if loading_type == Global.LOADING_TYPE_GAME:
		load_game()
	elif loading_type == Global.LOADING_TYPE_LEVEL:
		load_level()


func load_game():
	if !GameProgress.game_exists():
		GameProgress.new_game()
	var err = GameProgress.load_game()
	assert(err == OK, "Can\'t load save: save doesn\'t exists or save file are corrupted")
	load_level()


func load_level():
	for c in $Control/Viewports/WorldViewport.get_children():
		c.queue_free()
	ObjectRefs.level_player_spawns.clear()
	ObjectRefs.level = null
	
	world_state = GameState.world_state
	var level_obj : Node = null
	if world_state.level == "Desert":
		level_obj = load("res://Scenes/World/LevelDesert.tscn").instantiate()
	
	level_obj.ready.connect(prepare_level)
	$Control/Viewports/WorldViewport.add_child(level_obj)


func prepare_level():
	if !world_state || !ObjectRefs.level:
		assert(world_state && ObjectRefs.level, "Can\'t prepare level")
		# get_tree().quit(-1)
	
	ObjectRefs.level.spawn_player(world_state.spawn)
	if GameProgress.virgin:
		GameProgress.request_task(GameProgress.default_task)
		GameProgress.virgin = false


func _process(delta):
	if (Input.is_action_just_pressed("pause")
		&& !GameState.gameplay_state.dialoging
		&& !GameState.current_computer
		&& !get_tree().paused):
		ObjectRefs.ui_root.add_cover("res://Scenes/UI/PauseMenu.tscn", "pause_menu")
		get_tree().paused = true
