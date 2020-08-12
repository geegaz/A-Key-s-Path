extends "res://Scripts/Worlds/World.gd"

onready var Tips = $Path2D/Tips
onready var TipsImage = $Path2D/Tips/Sprite
onready var TipsAnimator = $Path2D/Tips/AnimationPlayer

func _ready():
	TipsImage.flip_h = true

func _on_Player_win():
	Global.set_transition(1, 1.0, "up")
	Global.goto_scene(next_level)


func _on_Tips_reached_offset(offset_id):
	match offset_id:
		1,4,6:
			TipsImage.flip_h = true
			continue
		

func _on_Tips_goto_next_offset(offset_id):
	match offset_id:
		1,2,5:
			TipsImage.flip_h = false
			continue

