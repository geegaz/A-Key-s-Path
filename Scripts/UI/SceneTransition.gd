extends Control

signal finished_loading

onready var _Transition = $Transition
onready var _AnimationPlayer = $AnimationPlayer

var loading: = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()

#################### Transition ####################
func _process(delta: float) -> void:
	pass

func transition_to_scene(scene_path: String, time: float):
	if loading:
		return
	
	# Setup loading animation
	_AnimationPlayer.playback_speed = 1/time
	
	loading = true
	_AnimationPlayer.play("transition_in")
	yield(_AnimationPlayer, "animation_finished")
	
	get_tree().change_scene(scene_path)
	
	_AnimationPlayer.play("transition_out")
	loading = false
