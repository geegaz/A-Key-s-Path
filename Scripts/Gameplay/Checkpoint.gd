extends Area2D

onready var _FlagSprite: AnimatedSprite = $FlagSprite
onready var _FlagParticles: CPUParticles2D = $FlagParticles
onready var _Collision: CollisionShape2D = $Collision
onready var _Audio: AudioStreamPlayer = $AudioStreamPlayer

func _on_Checkpoint_body_entered(body):
	if body.is_in_group("Player"):
		Global.current_checkpoint = position
		for node in get_tree().get_nodes_in_group("Checkpoint"):
			set_active(node == self)

func set_active(active: bool):
	_Collision.set_deferred("disabled",!active)
	if active:
		_FlagSprite.animation = "active"
		_FlagParticles.emitting = true
		_Audio.play()
	else:
		_FlagSprite.animation = "default"
