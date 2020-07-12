extends KinematicBody2D

signal checkpoint(node)
signal respawn
signal win

enum {IDLE, RUNNING, JUMPING, FALLING}
var state = IDLE

export var max_speed = 75.0
export var jump_force = 75.0
export var gravity = 2.0
export var gravity_strong = 4.0
export var accel = 0.1
export var coyote_time = 0.1

var left_control = true
var right_control = true
var jump_control = true
var on_ground = false
var alive = true

var velocity = Vector2()
var target_speed = 0.0
var target_gravity: float
var air_time = 0.0

var Animator: AnimationPlayer

func _ready():
	Animator = $AnimationPlayer
	target_gravity = gravity_strong

func _process(delta):
	var direction = 0.0
	if alive:
		if left_control and Input.is_action_pressed("left"):
			direction -= 1.0
		if right_control and Input.is_action_pressed("right"):
			direction += 1.0
		if jump_control and Input.is_action_just_pressed("jump") and air_time < coyote_time:
			velocity.y -= jump_force
			target_gravity = gravity
		if Input.is_action_just_released("jump") or velocity.y >= 0:
			target_gravity = gravity_strong
	else:
		target_gravity = gravity_strong
	
	target_speed = direction * max_speed
	
	if direction < 0.0:
		$Sprite.flip_h = true
	elif direction > 0.0:
		$Sprite.flip_h = false
	
	if on_ground:
		if !(state == RUNNING) and abs(direction) > 0.0:
			Animator.play("run")
			state = RUNNING
		elif !(state == IDLE) and abs(direction) <= 0.0:
			Animator.play("idle")
			state = IDLE
	else:
		if !(state == FALLING) and velocity.y > 0.0:
			Animator.play("fall")
			state = FALLING
		elif !(state == JUMPING) and velocity.y <= 0.0:
			Animator.play("jump")
			state = JUMPING

func _physics_process(delta):
	velocity.y += target_gravity
	velocity.x = lerp(velocity.x, target_speed, accel)
	
	if alive:
		velocity = move_and_slide(velocity, Vector2.UP)
	on_ground = ($RayCastLeft.is_colliding() or $RayCastRight.is_colliding() or is_on_floor())
	
	if on_ground:
		air_time = 0.0
	elif air_time < coyote_time:
		air_time += delta

func death():
	alive = false
	$Sprite.visible = false
	$Effector/EffectorCollider.disabled = true
	$DeathParticles.emitting = true
	$DeathTimer.start()

func respawn():
	alive = true
	$Sprite.visible = true
	$Effector/EffectorCollider.disabled = false
	
	velocity = Vector2(0.0, -100.0)
	emit_signal("respawn")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "jump" or anim_name == "fall":
		Animator.stop()

func _on_Effector_body_entered(body):
	if body.get_collision_layer_bit(1):
		print("death")
		call_deferred("death")
	elif body.get_collision_layer_bit(2):
		print("checkpoint")
		emit_signal("checkpoint", body)
	elif body.get_collision_layer_bit(3):
		print("win")
	else:
		print("death")
		call_deferred("death")

func _on_DeathTimer_timeout():
	respawn()
