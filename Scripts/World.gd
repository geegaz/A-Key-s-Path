extends Node2D

enum Controls {JUMP, LEFT, RIGHT}

var current_checkpoint: Node

var Player: KinematicBody2D
var WorldCamera: Camera2D
var Checkpoints: Array

var ControlJump
var ControlLeft
var ControlRight

# Called when the node enters the scene tree for the first time.
func _ready():
	Player = $Player
	WorldCamera = $Player/Camera2D
	set_camera_limits()
	
	Checkpoints = $Checkpoints.get_children()
	current_checkpoint = $StartPoint
	
	ControlJump = $ScreenPos/ControlJump
	ControlLeft = $ScreenPos/ControlLeft
	ControlRight = $ScreenPos/ControlRight

func set_camera_limits():
	var map_limits = $Terrain.get_used_rect()
	var map_cellsize = $Terrain.cell_size
	WorldCamera.limit_left = map_limits.position.x * map_cellsize.x
	WorldCamera.limit_right = map_limits.end.x * map_cellsize.x
	WorldCamera.limit_top = map_limits.position.y * map_cellsize.y
	WorldCamera.limit_bottom = map_limits.end.y * map_cellsize.y

func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)

func _on_Control_place_in_world(node):
	reparent(node, self)
	match node.control_type:
		Controls.JUMP:
			Player.jump_control = false
		Controls.LEFT:
			Player.left_control = false
		Controls.RIGHT:
			Player.right_control = false

func _on_Control_retrieve_from_world(node):
	reparent(node, $ScreenPos)
	node.retrieve()
	
	var tween = $Tween
	var target_pos
	match node.control_type:
		Controls.JUMP:
			Player.jump_control = true
			target_pos = $ScreenPos/ControlJumpPos.position
		Controls.LEFT:
			Player.left_control = true
			target_pos = $ScreenPos/ControlLeftPos.position
		Controls.RIGHT:
			Player.right_control = true
			target_pos = $ScreenPos/ControlRightPos.position
	tween.interpolate_property(node, "position",
		node.global_position,
		target_pos,
		0.2,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

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

func _on_RetrieveJump_pressed():
	_on_Control_retrieve_from_world(ControlJump)

func _on_RetrieveLeft_pressed():
	_on_Control_retrieve_from_world(ControlLeft)

func _on_RetrieveRight_pressed():
	_on_Control_retrieve_from_world(ControlRight)
