extends "res://Scripts/Worlds/WorldTemplate.gd"

onready var Tips = $Path2D/Tips
onready var TipsImage = $Path2D/Tips/Sprite
onready var TipsAnimator = $Path2D/Tips/AnimationPlayer

func _ready():
	WorldCamera.set_camera_limits($GridLimits)
	TipsImage.flip_h = true

func _on_Player_win():
	Global.set_transition(3)
	Global.goto_scene(next_level)

func _on_Tips_goto_next_offset(offset_id):
	match offset_id:
		_:
			TipsImage.flip_h = false
			continue

func _on_Tips_reached_offset(offset_id):
	match offset_id:
		2:
			Tips.hide()
		_:
			TipsImage.flip_h = true
			continue

func _on_CameraLimit2_body_entered(body):
	if body.is_in_group("Player"):
		$Objects/Triggers/CameraLimit2/CollisionShape2D.set_deferred("disabled",true)
		WorldCamera.set_camera_limits($CameraLimits)
		WorldCamera.shake(2.0, 1.0)
		
		var start = Vector2(68,48)
		var end = Vector2(71,49)
		for x in range(start.x,end.x+1):
			for y in range(start.y,end.y+1):
				$Tilemaps/TerrainTileMap.set_cell(x,y,0)
		$Tilemaps/TerrainTileMap.update_bitmask_region(start,end)
