extends "res://Scripts/Worlds/WorldTemplate.gd"

func _ready():
	pass

func _on_Player_win():
	Global.set_transition(3)
	Global.goto_scene(next_level)
