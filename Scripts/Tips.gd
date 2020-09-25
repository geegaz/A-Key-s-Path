extends PathFollow2D

signal reached_offset(offset_id)
signal goto_next_offset(offset_id)

export var speed = 300.0
export(Array, float) var offsets = []

var moving: bool = false
var next_offset_id: int = 0

onready var IdleTimer = $IdleTimer
onready var Animator = $AnimationPlayer
onready var Collider = $Area2D/Collider

func _ready():
	offset = 0.0
	randomize()

func _process(delta):
	if moving:
		offset += (speed*delta)
		if offset >= offsets[next_offset_id]-0.1:
			moving = false
			Collider.set_deferred("disabled", false)
			Animator.play("idle_1")
			
			IdleTimer.wait_time = randf()*2.0+0.5
			IdleTimer.start()
			
			emit_signal("reached_offset", next_offset_id)
			next_offset_id += 1
			

func goto_next_offset():
	if next_offset_id < offsets.size():
		
		moving = true
		Collider.set_deferred("disabled", true)
		Animator.play("run")
		
		emit_signal("goto_next_offset", next_offset_id)

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and !moving:
		goto_next_offset()

func _on_IdleTimer_timeout():
	if !moving:
		var anim = randi()%2
		match anim:
			0:
				Animator.play("idle_0")
			1:
				Animator.play("idle_1")
			_:
				Animator.play("idle_0")
		
		IdleTimer.wait_time = randf()*2.0+0.5
		IdleTimer.start()
