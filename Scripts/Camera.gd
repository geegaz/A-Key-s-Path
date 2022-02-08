extends Camera2D


export(NodePath) var camera_limits_rect
onready var _CameraLimitsRect: Control = get_node_or_null(camera_limits_rect)

export(Vector2) var target
export(int, FLAGS, "X", "Y") var lock_axis = 0

onready var _Tween = $Tween

func _ready():
	if _CameraLimitsRect:
		set_camera_limits(_CameraLimitsRect)

func _process(delta):
	pass

# Launches the shaking
#func shake(scale: float, time: float, intensity: float = 80.0):
#	$Shaker.shake(self, "offset", scale, time, intensity)

# Sets the limits of the camera based on a Control-based node
func set_camera_limits(rect_node: Control):
	var map_limits = rect_node.get_global_rect()
	limit_left = map_limits.position.x
	limit_right = map_limits.end.x
	limit_top = map_limits.position.y
	limit_bottom = map_limits.end.y
