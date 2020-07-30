extends Node2D

export(int) var next_level = 0

var current_checkpoint: Node

var Player: KinematicBody2D
var WorldCamera: Camera2D
var Checkpoints: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	Player = $Player
	WorldCamera = $Player/Camera2D
	set_camera_limits($CameraLimits)
	$CameraLimits/TextureRect.rect_size = $CameraLimits.rect_size
	
	Checkpoints = $Checkpoints.get_children()
	current_checkpoint = $StartPoint
	Player.position = current_checkpoint.position

func set_camera_limits(rect):
	var map_limits = rect.get_global_rect()
	WorldCamera.limit_left = map_limits.position.x
	WorldCamera.limit_right = map_limits.end.x
	WorldCamera.limit_top = map_limits.position.y
	WorldCamera.limit_bottom = map_limits.end.y

func _on_Player_checkpoint(node):
	var index = Checkpoints.find(node)
	if index >= 0 and current_checkpoint != node:
		Player.get_node("Sounds/Checkpoint").play()
		current_checkpoint = node
		for i in range(Checkpoints.size()):
			if i != index:
				Checkpoints[i].get_node("Player").play("flag_down")
		node.get_node("Player").play("flag_up")
		node.get_node("Particle").emitting = true

func _on_Player_respawn():
	Player.position = current_checkpoint.position

func _on_Player_win():
	Global.goto_level(next_level)

func _on_Player_die():
	$Player/Camera2D/Shaker.shake($Player/Camera2D, "offset", 2.0, 0.5)
