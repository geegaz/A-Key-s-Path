extends Control

signal finished_loading

onready var _Transition = $Transition
onready var _AnimationPlayer = $AnimationPlayer

var loading: = false
var current_scene: Node
var loader: ResourceInteractiveLoader = null
var loader_blocking_time: float = 100 #ms

# Called when the node enters the scene tree for the first time.
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	
	hide()

#################### Background loading ####################
func _process(delta: float) -> void:
	if loader:
		# Start loading
		var t = OS.get_ticks_msec()
		while OS.get_ticks_msec() < (t + loader_blocking_time):
			var err = loader.poll()
			if err == OK:
				# Loading...
				continue
			elif err == ERR_FILE_EOF:
				# Finished loading
				var resource: PackedScene = loader.get_resource()
				set_new_scene(resource)
				break
			else:
				# Error while loading
				printerr(err)
				break
		
		loader = null
		emit_signal("finished_loading")

func transition_to_scene(scene_path: String, time: float):
	if loading:
		return
	
	# Setup loading animation
	_AnimationPlayer.playback_speed = 1/time
	
	loading = true
	_AnimationPlayer.play("transition_in")
	yield(_AnimationPlayer, "animation_finished")
	
	loader = ResourceLoader.load_interactive(scene_path)
	
	yield(self, "finished_loading")
	_AnimationPlayer.play("transition_out")
	loading = false


func set_new_scene(scene_resource: PackedScene):
	current_scene.queue_free()
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
