extends Node2D

func _on_BackToMenu_pressed():
	Global.set_transition()
	Global.goto_scene("menu")
