extends Control

signal finished_loading

export(Array, Texture) var transition_textures = [
	preload("res://Assets/Sprites/transitions/horizontal.png"),
	preload("res://Assets/Sprites/transitions/vertical.png"),
	preload("res://Assets/Sprites/transitions/diagonal.png"),
	preload("res://Assets/Sprites/transitions/curtain.png")
]

onready var _Transition = $Transition
onready var _AnimationPlayer = $AnimationPlayer

var loader: ResourceInteractiveLoader = null
var loader_blocking_time: float = 100 #ms

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

#################### Background loading ####################
func _process(delta: float) -> void:
	if loader:
		var t = OS.get_ticks_msec()
		while OS.get_ticks_msec() < (t + loader_blocking_time):
			var err = loader.poll()
			if err == ERR_FILE_EOF:
				loader = null
				emit_signal("finished_loading")
				
				# TODO: actually adding the scene to the tree
				
				break
			else:
				loader = null
				emit_signal("finished_loading")
				break

func transition_to_scene(scene_path: String, time: float, type: int):
	# Setup loading animation
	_Transition.material.set_shader_param("transition_mask", transition_textures[type])
	_AnimationPlayer.playback_speed = 1/time
	
	_AnimationPlayer.play("transition_in")
	yield(_AnimationPlayer, "animation_finished")
	loader = ResourceLoader.load_interactive(scene_path)
	yield(self, "finished_loading")
	_AnimationPlayer.play("transition_out")
