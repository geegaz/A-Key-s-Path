extends ScrollContainer

export var custom_scroll_speed: float = 60
var custom_scroll: float = 0

func _process(delta):
	var dir: int = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	if dir != 0:
		custom_scroll += delta * custom_scroll_speed
	if custom_scroll >= 1:
		custom_scroll -= 1
		scroll_vertical += dir
