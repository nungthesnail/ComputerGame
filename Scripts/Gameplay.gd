extends Node


@onready var game_state = GameState
@onready var object_refs = ObjectRefs


func _process(delta):
	game_state._process(delta)


func start_computer(id : String):
	game_state.start_computer(id)
