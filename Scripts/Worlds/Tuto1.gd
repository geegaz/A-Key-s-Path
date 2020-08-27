extends "res://Scripts/Worlds/WorldTemplate.gd"

onready var Tips = $Path2D/Tips
onready var TipsImage = $Path2D/Tips/Sprite
onready var TipsAnimator = $Path2D/Tips/AnimationPlayer

func _ready():
	WorldCamera.set_camera_limits($GridLimits)
	TipsImage.flip_h = true

func _on_Player_win():
	pass

func _on_Tips_goto_next_offset(offset_id):
	match offset_id:
		1,2,5,7:
			TipsImage.flip_h = false
			continue

func _on_Tips_reached_offset(offset_id):
	match offset_id:
		1,4,6:
			TipsImage.flip_h = true
			continue


func _on_EndAnimation_body_entered(body):
	if body.is_in_group("Player"):
		$Player.controls_enabled = false
		$Player.animations_enabled = false
		$Player.velocity = Vector2(-200,-120)
		$Player._PlayerSprite.play("CutsceneFall")
		Tips.goto_next_offset()
		#$AnimationPlayer.play()
		#yield($AnimationPlayer, "animation_finished")
		WorldCamera.shake(4.0, 2.0)
		yield(get_tree().create_timer(3.0), "timeout")
		
		Global.set_transition(3)
		Global.goto_scene(next_level)
