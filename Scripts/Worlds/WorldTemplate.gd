extends Node2D

export(int) var level_id = 0
export(String, FILE, "*.tscn") var next_level

var current_checkpoint: Node

onready var Player: KinematicBody2D = $Player
onready var WorldCamera: Camera2D = $CameraSystem/Camera
onready var ControlsUI: Node2D = $ControlsUI
onready var GridLimits: ReferenceRect = $GridLimits
onready var StartPoint: Position2D = $StartPoint
onready var Checkpoints: Array = get_tree().get_nodes_in_group("Checkpoints")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Automatically resize the placement grid
	GridLimits.get_node("Grid").rect_size = GridLimits.rect_size
	
	# Place the player at the starting point
	current_checkpoint = StartPoint
	Player.position = current_checkpoint.position
	
	# Unlock the current level in the menu
	if Global.max_unlocked_level < level_id:
		Global.max_unlocked_level = level_id

func _input(event):
	if event.is_action_pressed("quit"):
		Global.switch_paused()

func _on_Player_checkpoint(node):
	# When the player reaches a checkpoint, find the corresponding
	# checkpoint and deactivate all the other ones.
	var index = Checkpoints.find(node)
	if index >= 0 and current_checkpoint != node:
		Player.get_node("Sounds/Checkpoint").play()
		current_checkpoint = node
		
		# Deactivate all the other checkpoints
		for i in range(Checkpoints.size()):
			if i != index:
				Checkpoints[i].get_node("Player").play("flag_down")
		node.get_node("Player").play("flag_up")
		node.get_node("Particle").emitting = true
		
		ControlsUI.retrieve_all()

func _on_Player_respawn():
	Player.position = current_checkpoint.position
	ControlsUI.retrieve_all()

func _on_Player_die():
	WorldCamera.shake(2.0, 0.5)
	var tween = $Tween
	tween.interpolate_property(Player, "position",
			Player.position, current_checkpoint.position, 1.0,
			tween.TRANS_SINE, tween.EASE_IN_OUT)
	tween.start()
