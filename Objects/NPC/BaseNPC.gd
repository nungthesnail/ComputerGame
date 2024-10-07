extends CharacterBody2D
class_name BaseNPC


@export var active : bool = true
@export var tags : Array[String] = []
@export var hint_text : String = "Нажмите [E] чтобы разговаривать"
@export var mission_scripts_class : Script
@export var sprite_flip : bool = false

var mission_scripts : Object = null


func _ready():
	if !is_in_group("interactive"):
		add_to_group("interactive")
	
	if mission_scripts_class:
		mission_scripts = mission_scripts_class.new()
		mission_scripts.tags = tags


func interact():
	if mission_scripts && active:
		if Tasking.current_task:
			if mission_scripts.has_method(Tasking.current_task.task_name):
				mission_scripts.call(Tasking.current_task.task_name)
		elif mission_scripts.has_method("default_dialog"):
			mission_scripts.call("default_dialog")


func _process(delta):
	$Sprite.flip_h = sprite_flip
	if !active:
		visible = false
		$CollisionShape.disabled = true
	else:
		visible = true
		$CollisionShape.disabled = false


func get_hint():
	return hint_text
