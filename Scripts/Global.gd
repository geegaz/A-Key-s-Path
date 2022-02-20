extends Node

# Controls
enum Controls {JUMP, LEFT, RIGHT}
var active_controls: Array = [
	true,
	true,
	true
]

# Sounds
enum {MASTER, SFX, MUSIC}

export(String, FILE, "*.json") var save_path: String = "res://save.json"
export(String, FILE, "*.tscn") var default_path = "res://Scenes/Main.tscn"
export(Array, String, FILE, "*.tscn") var level_paths = [
	"res://Scenes/Levels/Tutorial_1.tscn",
	"res://Scenes/Levels/Tutorial_2.tscn",
	"res://Scenes/Levels/Level_1.tscn"
]
export var levels_unlocked: int = 1
export(NodePath) var transition_screen_path = "OverlayLayer/SceneTransition"

var current_level: int = 0
var current_checkpoint: Vector2 = Vector2.ZERO
var volumes: Array = [100, 70, 70] setget set_volumes
var fullscreen: bool = false setget set_fullscreen
var screenshake: bool = true setget set_screenshake

onready var _TransitionScreen = get_node_or_null(transition_screen_path)
onready var _Shaker: Shaker = $Shaker
onready var _Music: MusicManager = $MusicManager


func _ready() -> void:
	_Music.musics = {
		"Part1_intro": preload("res://Assets/Music/reflexions-part1-in.ogg"),
		"Part1_loop": preload("res://Assets/Music/reflexions-part1.ogg"),
		"Part2_intro": preload("res://Assets/Music/reflexions-part2-in.ogg"),
		"Part2_loop": preload("res://Assets/Music/reflexions-part2.ogg"),
		"Part2_outro": preload("res://Assets/Music/reflexions-part2-out.ogg"),
		
		"Background_ambiance": preload("res://Assets/Sounds/background_ambiance.ogg")
	}

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		set_fullscreen(not fullscreen)

#################### Level handling ####################
# Workflow: 
# | get_next_level
# | unlock_level
# | goto_level - either level is valid or sends back to the main menu

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

func goto_scene(scene_path: String, transition_time: float = 0.5):
	# If no path has been given, replace it with default path
	if scene_path == "":
		scene_path = default_path
	
	print("Loading scene %s"%scene_path)
	# If a TransitionScreen is available, do a transition
	if _TransitionScreen:
		_TransitionScreen.transition_to_scene(scene_path, transition_time)
	# Else just load the next scene
	else:
		get_tree().change_scene(scene_path)


#################### Options handling ####################

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
	_Shaker.set_active(state)
	screenshake = state


#################### Helper Functions ####################

func create_at(scene: PackedScene, pos: Vector2, parent: Node = self)->Node:
	var new_scene: Node2D = scene.instance()
	if new_scene:
		parent.add_child(new_scene)
		new_scene.set_as_toplevel(true)
		new_scene.position = pos
		
	return new_scene
