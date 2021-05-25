extends Control

export(String, FILE, "*.tscn") var menu_scene = "res://Scenes/Main.tscn"

func _on_Back_pressed():
	Global.transition_to_scene(menu_scene)
