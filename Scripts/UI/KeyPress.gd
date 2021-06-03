extends Sprite

export(String) var control_action

enum {
	NORMAL, HOVER, 
	PRESSED, PRESSED_HOVER, 
	WORLD, WORLD_HOVER,
	DRAGGED,  DRAGGED_HOVER
}

func _process(delta):
	if Input.is_action_pressed(control_action):
		frame = PRESSED
	else:
		frame = NORMAL
