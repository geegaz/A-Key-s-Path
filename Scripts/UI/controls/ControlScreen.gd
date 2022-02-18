extends Control

onready var _ControlKeys: Dictionary = {
	$ControlJump: $ControlJump.position,
	$ControlLeft: $ControlLeft.position,
	$ControlRight: $ControlRight.position
}
onready var _ControlButtons: Array = [
	$BarSlots/RetrieveJump,
	$BarSlots/RetrieveLeft,
	$BarSlots/RetrieveRight
]
onready var _BarBase: = $BarBase

func _ready():
	var index: int = 0
	for control in _ControlKeys:
		if control:
			control.connect("dragged", self, "_on_ControlKey_dragged", [control])
			control.connect("placed", self, "_on_ControlKey_placed", [control])
			control.connect("retrieved", self, "_on_ControlKey_retrieved", [control])
			
			_ControlButtons[index].connect("pressed", self, "_on_ControlKey_retrieved", [control])
		index += 1

func _process(delta):
	pass

#func _get_camera_pos():
#	# https://godotengine.org/qa/4750/get-center-of-the-current-camera2d
#	var vtrans = get_canvas_transform()
#	return -vtrans.get_origin() / vtrans.get_scale()

func reparent(node: Node2D, target: Node):
	# Detach from old parent
	var source = node.get_parent()
	source.remove_child(node)
	# Attach to new parent
	target.add_child(node)
	node.set_owner(target)

func retrieve_all():
	for control in _ControlKeys:
		if control and control.in_world:
			control.set_physical(false)
			reparent(control, self)
			retrieve_control(control)

func place_control(control: Node2D):
	control.position = control.get_absolute_world_position(control.position)
	Global.active_controls[control.control_type] = false

func retrieve_control(control: Node2D):
	# Get the control's position in global coordinates,
	# and reparent the control to the ControlsScreen
	control.position = control.get_absolute_local_position(control.position)
	Global.active_controls[control.control_type] = true
	
	# Smoothly interpolate the control's position to ControlsScreen
	var tween = $Tween
	tween.remove(control)
	tween.interpolate_property(control, "position",
		control.position,
		_ControlKeys[control],
		0.2, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()


func _on_ControlKey_dragged(control):
	control.set_physical(false)
	reparent(control, self)
	place_control(control)

func _on_ControlKey_placed(control):
	if _BarBase.get_rect().has_point(control.get_global_mouse_position()):
		control.position = control.get_absolute_world_position(control.position)
		_on_ControlKey_retrieved(control)
	else:
		control.set_physical(true)
		reparent(control, get_tree().root)
		place_control(control)

func _on_ControlKey_retrieved(control):
	control.set_physical(false)
	reparent(control, self)
	retrieve_control(control)
