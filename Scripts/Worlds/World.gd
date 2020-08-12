extends Node2D

export(int) var level_id = 0
export(String, FILE, "*.tscn") var next_level

var current_checkpoint: Node

onready var Player: KinematicBody2D = $Player
onready var WorldCamera: Camera2D = $Player/Camera2D
onready var Shaker: Node = $Player/Camera2D/Shaker
onready var CameraLimits: ReferenceRect = $CameraLimits
onready var StartPoint: Position2D = $StartPoint
onready var Checkpoints: Array = get_tree().get_nodes_in_group("Checkpoints")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_camera_limits(CameraLimits)
	CameraLimits.get_node("TextureRect").rect_size = CameraLimits.rect_size
	
	current_checkpoint = StartPoint
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

func _on_Player_die():
	Shaker.shake(WorldCamera, "offset", 2.0, 0.5)
