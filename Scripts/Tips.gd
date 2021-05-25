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

func _process(delta):
	if moving:
		# Wen moving, move with the given speed (px/s)
		offset += (speed*delta)
		if offset >= offsets[next_offset_id]-0.1:
			# When reached the target offset,
			# stop Tips and make it able to detect the player again
			moving = false
			Collider.set_deferred("disabled", false)
			Animator.play("idle_1")
			
			# Start the timer to play random animations
			IdleTimer.wait_time = randf()*2.0+0.5
			IdleTimer.start()
			
			emit_signal("reached_offset", next_offset_id)		

func goto_next_offset(new_offset_id):
	if new_offset_id < offsets.size():
		# If the new offset id is valid, set it as next offset to reach
		next_offset_id = new_offset_id
		
		# Start making Tips move,
		# and prevent the player from interacting with it until it reached 
		# the next offset
		moving = true
		Collider.set_deferred("disabled", true)
		Animator.play("run")
		
		emit_signal("goto_next_offset", next_offset_id)
	elif loop:
		pass


func _on_Area2D_body_entered(body):
	if body.is_in_group("Player") and !moving:
		goto_next_offset(next_offset_id + 1)

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
