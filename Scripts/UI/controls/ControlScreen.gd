extends Node2D

signal control_placed(control_type)
signal control_retrieved(control_type)

onready var ControlBlocks: Array = [
	$ControlJump,
	$ControlLeft,
	$ControlRight
]
onready var ControlPos: Array = [
	$ControlJumpPos,
	$ControlLeftPos,
	$ControlRightPos
]

func _ready():
	for control in ControlBlocks:
		if control:
			control.connect("place", self, "_on_PlaceControl")
			control.connect("retrieve", self, "_on_RetrieveControl")
	
	show()

func _process(delta):
	position = _get_camera_pos()

func _get_camera_pos():
	# https://godotengine.org/qa/4750/get-center-of-the-current-camera2d
	var vtrans = get_canvas_transform()
	return -vtrans.get_origin() / vtrans.get_scale()

func retrieve_all():
	for control in ControlBlocks:
		if control and control.in_world:
			retrieve_control(control.control_type)

func place_control(control_type: int):
	var control = ControlBlocks[control_type]
	if !control:
		return
	control.set_as_toplevel(true)
	Global.active_controls[control_type] = false

	# If another node wants to detect control changes
	emit_signal("control_placed", control_type)

func retrieve_control(control_type: int):
	var control = ControlBlocks[control_type]
	if !control:
		return
	# Get the control's position in global coordinates,
	# and reparent the control to the ControlsScreen
	control.position = control.get_global_transform_with_canvas().origin
	control.set_as_toplevel(false)
	Global.active_controls[control_type] = true
	control.retrieve()
	
	# If another node wants to detect control changes
	emit_signal("control_retrieved", control_type)
	
	# Smoothly interpolate the control's position to ControlsScreen
	var tween = $Tween
	tween.remove(control)
	tween.follow_property(control, "position",
		control.position,
		ControlPos[control_type], "position",
		0.2, Tween.TRANS_BACK, Tween.EASE_OUT)
	tween.start()


func _on_PlaceControl(control_type):
	place_control(control_type)


func _on_RetrieveControl(control_type):
	retrieve_control(control_type)

func _on_RetrieveAll():
	retrieve_all()
