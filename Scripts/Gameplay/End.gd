extends Area2D

signal finished_level

onready var _StateMachine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_ActivationArea_body_entered(body):
	if body.is_in_group("Player"):
		_StateMachine.travel("hover")

func _on_ActivationArea_body_exited(body):
	if body.is_in_group("Player"):
		_StateMachine.travel("close")

func _on_End_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("finished_level")
		var next_level = Global.get_next_level()
		Global.unlock_level(next_level)
		Global.goto_level(next_level)
