extends Node

signal zone_entered(center, free_x, free_y, zoom)

export(bool) var free_x = false
export(bool) var free_y = false
export(float, 0.01, 2.0) var zoom = 1.0

func _on_CameraZone_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("zone_entered", self.position, free_x, free_y, zoom)
