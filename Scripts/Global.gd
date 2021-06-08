extends Node


func _ready():
	pass


##################### Level Management #####################
# Used inside level
var current_world: int = -1
var current_level: int = -1
var current_checkpoint: Node = null
# World data
var worlds_data = [
	{
		"name": "World 1",
		"levels": [
			"res://Scenes/Levels/World1_Level1.tscn"
		],
		"unlocked_levels": 0
	}
]

func is_level_valid(world: int, level: int)->bool:
	if world < worlds_data.size():
		if level < worlds_data[world]["levels"].size():
			return true
		else:
			print("Invalid level: %s %s"%[world,level])
	else:
		print("Invalid world: %s %s"%[world,level])
	return false

# Behavior for invalid values: 
# returns an empty string if the world or level is outside of existing values
func get_level_path(world: int, level: int)->String:
	if is_level_valid(world, level):
		return worlds_data[world]["levels"][level]
	return ""

# Behavior for invalid values: 
# doesn't unlock any new levels if the world or level is outside of existing values
func unlock_level(world: int, level: int):
	if is_level_valid(world, level):
		worlds_data[world]["unlocked_levels"] = level+1


##################### Transition Management #####################
# TransitionScreen node
export(NodePath) var transition_screen_path = "TransitionLayer/TransitionScreen"
onready var _TransitionScreen = get_node_or_null(transition_screen_path)
# Transition types
enum {HORIZONTAL, VERTICAL, DIAGONAL, CURTAIN}

func goto_scene(scene_path: String, type: int = DIAGONAL, time: float = 1.0):
	# If no path has been given, don't do anything
	if scene_path == "":
		return
	# Else if a TransitionScreen is available, do a transition
	elif _TransitionScreen:
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


##################### Options Management #####################
# Sounds
var volumes: Array = [0.7, 0.7, 0.7] setget set_volumes
enum {MASTER, SFX, MUSIC}
# Video
var fullscreen: bool = false setget set_fullscreen
var screenshake: bool = true setget set_screenshake

func get_volume_linear(bus: int)->float:
	return db2linear(AudioServer.get_bus_volume_db(bus))

func set_volume_linear(bus: int, volume_scale: float):
	var volume = linear2db(volume_scale)
	AudioServer.set_bus_volume_db(bus, volume)

func set_volumes(new_volumes: Array):
	volumes = new_volumes
	for i in volumes.size():
		set_volume_linear(i, volumes[i])

func set_fullscreen(state: bool):
	OS.window_fullscreen = state
	fullscreen = state

func set_screenshake(state: bool):
	screenshake = state
