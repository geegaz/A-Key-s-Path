extends Area2D

onready var _Tween = $Tween

func _ready():
# warning-ignore:return_value_discarded
	connect("body_entered", self, "_on_Area2D_body_entered")
# warning-ignore:return_value_discarded
	connect("body_exited", self, "_on_Area2D_body_exited")
	
	modulate.a = 0.0

func text_shown(state: bool):
	if state:
		_Tween.interpolate_property(self, "modulate:a", modulate.a, 1.0, 1.0)
	else:
		_Tween.interpolate_property(self, "modulate:a", modulate.a, 0.0, 1.0)
	if !_Tween.is_active():
			_Tween.start()
	
func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		text_shown(true)

func _on_Area2D_body_exited(body):
	if body.is_in_group("Player"):
		text_shown(false)
