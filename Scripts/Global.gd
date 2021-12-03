extends Node

export(String, FILE, "*.json") var SAVE_PATH: String = "res://save.json"

##################### Level Management #####################
# Used inside level
var current_level: int = -1
var current_checkpoint: Vector2 = Vector2.ZERO
# World data
export(String, FILE, "*.tscn") var default_path = "res://Scenes/Main.tscn"
export(Array, String, FILE, "*.tscn") var level_paths = [
	"res://Scenes/Levels/Tutorial_1.tscn"
]
export var levels_unlocked: int = 1

##################### Transition Management #####################
# TransitionScreen node
export(NodePath) var transition_screen_path = "TransitionLayer/TransitionScreen"
onready var _TransitionScreen = get_node_or_null(transition_screen_path)
# Transition types
enum {HORIZONTAL, VERTICAL, DIAGONAL, CURTAIN}

##################### Options Management #####################
# Sounds
enum {MASTER, SFX, MUSIC}
var volumes: Array = [100, 70, 70] setget set_volumes
# Video
var fullscreen: bool = false setget set_fullscreen
var screenshake: bool = true setget set_screenshake



# Workflow: get_next_level -> unlock_level -> goto_level
func is_level_valid(level: int)->bool:
	return level < level_paths.size()

func get_next_level()->int:
	return current_level + 1

# Behavior for invalid values: 
# returns an empty string if the level is outside of existing values
func get_level_path(level: int)->String:
	if is_level_valid(level):
		return level_paths[level]
	return ""

# Behavior for invalid values: 
# doesn't unlock any new levels if the world or level is outside of existing values
func unlock_level(level: int):
	if is_level_valid(level):
		levels_unlocked = level+1

func goto_level(level: int):
	current_level = level
	goto_scene(get_level_path(level))

func goto_scene(scene_path: String, type: int = DIAGONAL, time: float = 1.0):
	# If no path has been given, replace it with default path
	if scene_path == "":
		scene_path = default_path
		
	# Else if a TransitionScreen is available, do a transition
	if _TransitionScreen:
		if !_TransitionScreen.in_transition:
			_TransitionScreen.transition_start(type, time/2.0)
			# Wait for the middle of the transition
			yield(_TransitionScreen, "transition_middle")
			get_tree().change_scene(scene_path)
			# Reveal the next scene
			_TransitionScreen.transition_end(type, time/2.0)
	# If there is no TransitionScreen just load the next scene
	else:
		get_tree().change_scene(scene_path)

func get_volume_linear(bus: int)->float:
	return db2linear(AudioServer.get_bus_volume_db(bus))*100

func set_volume_linear(bus: int, volume_scale: float):
	AudioServer.set_bus_volume_db(bus, linear2db(volume_scale/100))

func set_volumes(new_volumes: Array):
	volumes = new_volumes
	for i in volumes.size():
		set_volume_linear(i, volumes[i])

func set_fullscreen(state: bool):
	OS.window_fullscreen = state
	fullscreen = state

func set_screenshake(state: bool):
	screenshake = state
