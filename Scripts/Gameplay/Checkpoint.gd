extends Area2D

export(PackedScene) var activate_effect: PackedScene

onready var _Collision: CollisionShape2D = $Collision
onready var _Audio: AudioStreamPlayer = $CheckpointSound

onready var _SpriteActive: Sprite = $SpriteActive
onready var _Sprite: Sprite = $Sprite

func _on_Checkpoint_body_entered(body):
	if body.is_in_group("Player"):
		Global.current_checkpoint = position
		for node in get_tree().get_nodes_in_group("Checkpoint"):
			node.set_active(node == self)

func set_active(active: bool):
	_Collision.set_deferred("disabled", active)
	_SpriteActive.visible = active
	_Sprite.visible = not active
	if active:
		Global.create_at(activate_effect, global_position, self)
		_Audio.play()
