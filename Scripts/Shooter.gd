extends Node2D

export(float, 0.1, 10.0) var delay = 1.0
export(float, 0.0, 10.0) var delay_offset = 1.0
export(float) var speed = 100.0
export var muted = false

var wait_time: float

var shooting = true
var fireball = preload("res://Scenes/Objects/Fireball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.wait_time = delay_offset

func _on_Timer_timeout():
	$Timer.wait_time = delay
	if shooting:
		$Effect/Player.stop()
		$Effect/Player.play("shoot_effect")
		
		if !muted:
			$Sound.play()
		
		var new_fireball = fireball.instance()
		new_fireball.init(Vector2.UP.rotated(self.rotation), speed)
		new_fireball.position = self.position
		get_parent().add_child(new_fireball)
		

func _on_VisibilityNotifier2D_screen_entered():
	shooting = true

func _on_VisibilityNotifier2D_screen_exited():
	shooting = false
