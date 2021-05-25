extends Control

signal transition_middle

export(Array, Texture) var transition_textures = [
	preload("res://Assets/Sprites/transitions/horizontal.png"),
	preload("res://Assets/Sprites/transitions/vertical.png"),
	preload("res://Assets/Sprites/transitions/diagonal.png"),
	preload("res://Assets/Sprites/transitions/curtain.png")
]

onready var _Transition = $Transition
onready var _AnimationPlayer = $AnimationPlayer
var in_transition: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func transition_start(type: int, time: float):
	show()
	_Transition.material.set_shader_param("transition_mask", transition_textures[type])
	_AnimationPlayer.playback_speed = 1/time
	_AnimationPlayer.play("transition_in")
	
	in_transition = true

func transition_end(type: int, time: float):
	_Transition.material.set_shader_param("transition_mask", transition_textures[type])
	_AnimationPlayer.playback_speed = 1/time
	_AnimationPlayer.play("transition_out")
	
	in_transition = false


func _on_AnimationPlayer_animation_finished(_anim_name):
	if in_transition:
		emit_signal("transition_middle")
	else:
		hide()
