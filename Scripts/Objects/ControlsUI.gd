extends Node2D

signal control_placed(control_type)
signal control_retrieved(control_type)

enum Controls {JUMP, LEFT, RIGHT}

onready var ControlJump: KinematicBody2D = $ControlJump
onready var ControlLeft: KinematicBody2D = $ControlLeft
onready var ControlRight: KinematicBody2D = $ControlRight

onready var ControlPos: Array = [
		$ControlJumpPos,
		$ControlLeftPos,
		$ControlRightPos
	]

func _ready():
	show()

func _process(delta):
	position = _get_camera_pos()

func _get_camera_pos():
	# https://godotengine.org/qa/4750/get-center-of-the-current-camera2d
	var vtrans = get_canvas_transform()
	return -vtrans.get_origin() / vtrans.get_scale()
	

func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)

func retrieve_all():
	for control in [ControlLeft, ControlRight, ControlJump]:
		if control and control.in_world:
			_on_Control_retrieve_from_world(control)

func _on_Control_place_in_world(node):
	reparent(node, get_parent())
	emit_signal("control_placed", node.control_type)

func _on_Control_retrieve_from_world(node):
	node.position = node.get_global_transform_with_canvas().origin
	reparent(node, self)
	
	node.retrieve()
	emit_signal("control_retrieved", node.control_type)
	
	var tween = $Tween
	var target_pos = ControlPos[node.control_type].position
	tween.interpolate_property(node, "position",
		node.position,
		target_pos,
		0.2,Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func _on_RetrieveJump_pressed():
	if ControlJump:
		_on_Control_retrieve_from_world(ControlJump)

func _on_RetrieveLeft_pressed():
	if ControlLeft:
		_on_Control_retrieve_from_world(ControlLeft)

func _on_RetrieveRight_pressed():
	if ControlRight:
		_on_Control_retrieve_from_world(ControlRight)
