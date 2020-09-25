extends "res://Scripts/Worlds/WorldTemplate.gd"

onready var Tips = $Path2D/Tips
onready var TipsImage = $Path2D/Tips/Sprite
onready var TipsAnimator = $Path2D/Tips/AnimationPlayer

func _ready():
	WorldCamera.set_camera_limits($GridLimits)
	TipsImage.flip_h = true
	
	$ControlsUI.hide()

func _on_Player_win():
	pass

func _on_Tips_goto_next_offset(offset_id):
	match offset_id:
		_:
			TipsImage.flip_h = false
			continue

func _on_Tips_reached_offset(offset_id):
	match offset_id:
		_:
			TipsImage.flip_h = true
			continue


func _on_EndAnimation_body_entered(body):
	if body.is_in_group("Player"):
		WorldCamera.shake(2.0, 1.0)
		
		$Player.controls_enabled = false
		$Player.animations_enabled = false
		$Player.velocity = Vector2(-200,-120)
		$Player._PlayerSprite.play("CutsceneFall")
		Tips.goto_next_offset()
		
		yield(get_tree().create_timer(1.5),"timeout")
		break_end_platforms()
		yield(get_tree().create_timer(0.5),"timeout")
		
		Global.set_transition(3)
		Global.goto_scene(next_level)

func retrieve_all_controls():
	$Objects/BreakParticles.emitting = true
	for node in [$Objects/ControlPropJump,$Objects/ControlPropLeft,$Objects/ControlPropRight]:
		node.hide()
	for node in [$Objects/ControlRight,$Objects/ControlLeft,$Objects/ControlJump]:
		node.visible = true
		$ControlsUI._on_Control_retrieve_from_world(node)

func break_end_platforms():
	$Tilemaps/TerrainTileMap.set_cell(57,11,-1)
	$Tilemaps/TerrainTileMap.set_cell(58,11,-1)
	$Tilemaps/CPUParticles2D.emitting = true
	
	$Player.animations_enabled = true
	$Player.velocity = Vector2(0,-100)
	
