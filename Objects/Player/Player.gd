extends CharacterBody2D


var default_speed : float = 75.0
var speed : float = default_speed

var interactives : Array = []


func _init():
	ObjectRefs.player = self


func _physics_process(delta):
	var dir = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	).normalized() * speed
	
	if Gameplay.game_state.player_state.active:
		velocity = dir
		move_and_slide()


func _process(delta):
	if Gameplay.game_state.player_state.active:
		speed = default_speed * 1.3 if Input.is_action_pressed("shift") else default_speed
		if Input.is_action_just_pressed("interact"):
			for i in interactives:
				i.interact()


func interactive_collision(object):
	if object.is_in_group("interactive"):
		if object.has_method("get_hint"):
			get_hint_label().set_primary_text(object.get_hint())
		interactives.append(object)


func interactive_collision_end(object):
	if object.is_in_group("interactive"):
		if object.has_method("get_hint"):
			get_hint_label().clear_primary_text()
		interactives.erase(object)


func get_hint_label():
	return $Hint
