class_name GameCamera extends Camera2D


@export var target_path : NodePath
@export var follow_target : bool = true
@export var fixed_position : Vector2 = Vector2.ZERO
@export var fixed_point : Node2D = null
var target : Node2D = null


func _ready():
	if target_path && !is_instance_valid(target):
		target = get_node(target_path)
	ObjectRefs.camera = self
	zoom = Vector2(3,3)


func _process(delta):
	if follow_target && is_instance_valid(target):
		pass # global_position = target.global_position
	else:
		if is_instance_valid(fixed_point):
			pass # global_position = fixed_point.global_position
		else:
			global_position = fixed_position
