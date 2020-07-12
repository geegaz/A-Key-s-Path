extends Node2D

enum Directions {UP, RIGHT, DOWN, LEFT}
export(Directions) var direction
export(float, 0.0, 10.0) var delay = 1.0
export(float) var speed = 1.0

var vec_dirs = [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
var Animations = ["glint_up", "glint_right", "glint_down", "glint_left"]

var shooting = true
var fireball = preload("res://Scenes/Objects/Fireball.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play(Animations[direction])
	$Timer.wait_time = delay
	$Effect.rotation_degrees = direction*90

func _on_Timer_timeout():
	if shooting:
		$Effect/Player.stop()
		$Effect/Player.play("shoot_effect")
		
		var new_fireball = fireball.instance()
		new_fireball.init(vec_dirs[direction], speed)
		new_fireball.position = self.position
		get_parent().add_child(new_fireball)
		

func _on_VisibilityNotifier2D_screen_entered():
	shooting = true

func _on_VisibilityNotifier2D_screen_exited():
	shooting = false
