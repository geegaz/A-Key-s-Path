extends Node2D

enum Controls {JUMP, LEFT, RIGHT}

var Player: KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Player = $Player

func _process(delta):
	pass

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
		Controls.LEFT:
			Player.left_control = true
		Controls.RIGHT:
			Player.right_control = true
