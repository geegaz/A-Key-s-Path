extends KinematicBody2D

export var speed: float = 100
export var destroy_effect: PackedScene

onready var _Visibility: = $VisibilityNotifier2D

func _ready() -> void:
	_Visibility.connect("screen_exited", self, "queue_free")

func _physics_process(delta):
	var collision = move_and_collide(Vector2.RIGHT.rotated(rotation) * speed * delta)
	if collision:
		destroy()

func destroy()->void:
	var effect: = Global.create_at(destroy_effect, global_position, get_parent())
	effect.rotation = rotation
	queue_free()
