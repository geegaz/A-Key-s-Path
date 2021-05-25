extends Node

# warning-ignore:unused_signal
signal change_scene_ready

var world_unlocked_levels = [
	0
]
var sfx_volume
var music_volume
var screenshake = true

var show_levels = false

export(NodePath) var transition_screen_path = "TransitionLayer/TransitionScreen"
onready var _TransitionScreen = get_node_or_null(transition_screen_path)

enum {HORIZONTAL, VERTICAL, DIAGONAL, CURTAIN}

func _ready():
	pass

func transition_to_scene(scene_path: String, type: int = DIAGONAL, time: float = 1.0):
	if _TransitionScreen:
		if !_TransitionScreen.in_transition:
			_TransitionScreen.transition_start(type, time/2.0)
			
			yield(_TransitionScreen, "transition_middle")
			goto_scene(scene_path)
			
			_TransitionScreen.transition_end(type, time/2.0)
	else:
		goto_scene(scene_path)
			

func goto_scene(scene_path: String):
	if scene_path == "":
		return
	else:
# warning-ignore:return_value_discarded
		get_tree().change_scene(scene_path)

