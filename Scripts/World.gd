extends Node2D

var current_checkpoint: Node

var Player: KinematicBody2D
var WorldCamera: Camera2D
var Checkpoints: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	Player = $Player
	WorldCamera = $Player/Camera2D
	WorldCamera.set_limits($CameraLimits)
	$CameraLimits/TextureRect.rect_size = $CameraLimits.rect_size
	
	Checkpoints = $Checkpoints.get_children()
	current_checkpoint = $StartPoint
	Player.position = current_checkpoint.position

func _on_Player_checkpoint(node):
	var index = Checkpoints.find(node)
	if index >= 0 and current_checkpoint != node:
		$Sounds/Checkpoint.play()
		current_checkpoint = node
		for i in range(Checkpoints.size()):
			if i != index:
				Checkpoints[i].get_node("Player").play("flag_down")
		node.get_node("Player").play("flag_up")
		node.get_node("Particle").emitting = true

func _on_Player_respawn():
	Player.position = current_checkpoint.position

func _on_Player_win():
	Global.goto_scene("res://Scenes/Finish.tscn")
