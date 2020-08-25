extends Node2D

export(int) var level_id = 0
export(String, FILE, "*.tscn") var next_level

var current_checkpoint: Node

onready var Player: KinematicBody2D = $Player
onready var WorldCamera: Camera2D = $Player/Camera
onready var GridLimits: ReferenceRect = $GridLimits
onready var StartPoint: Position2D = $StartPoint
onready var Checkpoints: Array = get_tree().get_nodes_in_group("Checkpoints")

# Called when the node enters the scene tree for the first time.
func _ready():
	GridLimits.get_node("Grid").rect_size = GridLimits.rect_size
	
	current_checkpoint = StartPoint
	Player.position = current_checkpoint.position

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
	WorldCamera.shake(2.0, 0.5)
