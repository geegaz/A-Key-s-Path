tool
extends Control

func _draw() -> void:
	var rect: Rect2 = get_rect()
	for i in (int(rect.size.x) / 16) + 1:
		draw_line(Vector2(i * 16, 0), Vector2(i * 16, rect.size.y), Color.white)
	for i in (int(rect.size.y) / 16) + 1:
		draw_line(Vector2(0, i * 16),Vector2(rect.size.x, i * 16), Color.white)
