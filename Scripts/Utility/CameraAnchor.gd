extends Area2D

export(int, FLAGS, "X", "Y") var lock_axis = 0
export(float, 0.1, 10.0) var zoom = 1.0

onready var _Camera: Camera2D = get_tree().get_nodes_in_group("Camera").front()

func _ready() -> void:
	connect("body_entered", self,"_on_CameraAnchor_body_entered")

func _on_CameraAnchor_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		if _Camera:
			pass
