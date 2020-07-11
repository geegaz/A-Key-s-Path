extends Node2D

enum Controls {JUMP, LEFT, RIGHT}

var Player: KinematicBody2D
var WorldCamera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Player = $Player
	WorldCamera = $Player/Camera2D
	set_camera_limits()
	
func _process(delta):
	pass

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
	print("place")
	print(node)
	print(node.get_parent())
	reparent(node, self)
	match node.control_type:
		Controls.JUMP:
			Player.jump_control = false
		Controls.LEFT:
			Player.left_control = false
		Controls.RIGHT:
			Player.right_control = false

func _on_Control_retrieve_from_world(node):
	print("retrieve")
	print(node)
	print(node.get_parent())
	reparent(node, $ScreenPos)
	match node.control_type:
		Controls.JUMP:
			Player.jump_control = true
			node.position = $ScreenPos/ControlJumpPos.position
		Controls.LEFT:
			Player.left_control = true
			node.position = $ScreenPos/ControlLeftPos.position
		Controls.RIGHT:
			Player.right_control = true
			node.position = $ScreenPos/ControlRightPos.position
