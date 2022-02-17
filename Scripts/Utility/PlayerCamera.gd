extends Camera2D

export(NodePath) var target_node
onready var _Target: Node2D = get_node_or_null(target_node)

func _ready():
	set_as_toplevel(true)
	
	var parent = get_parent()
	if parent.is_in_group("Player"):
		parent.connect("died", self, "_on_Player_died")
		parent.connect("respawned", self, "_on_Player_respawned")

func _process(delta):
	if _Target:
		position = _Target.position

# Sets the limits of the camera based on a Control-based node
func set_camera_limits(rect_node: Control):
	var map_limits = rect_node.get_global_rect()
	limit_left = map_limits.position.x
	limit_right = map_limits.end.x
	limit_top = map_limits.position.y
	limit_bottom = map_limits.end.y

func _on_Player_died():
	Global._Shaker.add_shake(self, "offset", Vector2(5, 10), 1.0, 10)

func _on_Player_respawned():
	pass # Replace with function body.
