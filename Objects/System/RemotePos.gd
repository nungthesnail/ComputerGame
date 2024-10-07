extends RemoteTransform2D

enum RemoteType {
	PLAYER = 1,
	OTHER = 2
}
@export var type : RemoteType = RemoteType.PLAYER
var target : NodePath


func _ready():
	target = get_path_to(ObjectRefs.camera)


func _process(delta):
	if !is_instance_valid(ObjectRefs.camera):
		return
	elif is_instance_valid(ObjectRefs.camera) && !target:
		target = get_path_to(ObjectRefs.camera)
	
	if ObjectRefs.camera.follow_target && type == RemoteType.PLAYER:
		remote_path = target
	elif !ObjectRefs.camera.follow_target && ObjectRefs.camera.fixed_point == self:
		remote_path = target
	else:
		remote_path = NodePath("")
