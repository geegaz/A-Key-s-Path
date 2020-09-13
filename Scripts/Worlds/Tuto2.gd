extends "res://Scripts/Worlds/WorldTemplate.gd"

func _ready():
	WorldCamera.set_camera_limits($CameraLimits0)

func _on_Player_win():
	Global.set_transition(3)
	Global.goto_scene(next_level)

func _on_TriggerRoom1_body_entered(body):
	if body.is_in_group("Player"):
		WorldCamera.set_camera_limits($GridLimits)
		$Objects/Triggers/UnlockCamera/CollisionShape2D.set_deferred("disabled", true)

func _on_ShowHandTutorial_body_entered(body):
	if body.is_in_group("Player"):
		pass


func _on_RetrieveHandTutorial_body_entered(body):
	if body.is_in_group("Player"):
		pass
