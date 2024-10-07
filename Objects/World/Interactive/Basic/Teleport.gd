extends Area2D


@export var active : bool = true
@export var target_path : NodePath
@export var destination : String = ""
@export var hint_text : String = "Нажмите [E] чтобы войти"
var target = null
var player_entered


func _ready():
	target = get_node(target_path)


func get_hint():
	return hint_text


func interact():
	if !is_instance_valid(target):
		push_warning("Target is invalid")
		return
	if !active:
		return
	
	GameState.player_state.active = false
	ObjectRefs.ui_root.get_ui_gameplay().play_animation("transition")
	$AnimationPlayer.play("transition")


func teleport():
	ObjectRefs.player.global_position = target.global_position


func teleport_end():
	GameState.player_state.active = true
	Tasking.update_task(Tasking.TaskUpdate.TYPE_TELEPORTED, {"destination": destination})


func _process(delta):
	$PointLight.enabled = active
	monitoring = active
	monitorable = active
