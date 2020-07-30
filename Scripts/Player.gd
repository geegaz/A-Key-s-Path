extends KinematicBody2D

signal checkpoint(node)
signal die
signal respawn
signal win

enum Controls {JUMP, LEFT, RIGHT}
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

func _process(_delta):
	if target_speed < 0.0:
		$Sprite.flip_h = true
	elif target_speed > 0.0:
		$Sprite.flip_h = false
	
	if on_ground:
		if !(state == RUNNING) and abs(target_speed) > 0.0:
			Animator.play("run")
			state = RUNNING
			$Sounds/Running.play()
		elif !(state == IDLE) and abs(target_speed) <= 0.0:
			Animator.play("idle")
			state = IDLE
			$Sounds/Running.stop()
	else:
		$Sounds/Running.stop()
		if !(state == FALLING) and velocity.y > 0.0:
			Animator.play("fall")
			state = FALLING
		elif !(state == JUMPING) and velocity.y <= 0.0:
			Animator.play("jump")
			state = JUMPING

func _physics_process(delta):
	var direction = 0.0
	if alive:
		if right_control and Input.is_action_pressed("right"):
			direction += 1
		if left_control and Input.is_action_pressed("left"):
			direction -= 1
		if jump_control and Input.is_action_just_pressed("jump") and air_time < coyote_time:
			velocity.y -= jump_force
			target_gravity = gravity
			
			randomize()
			$Sounds/Jump.pitch_scale = (randf()*0.8+0.6)
			$Sounds/Jump.play()
			create_jump_effect()
			
		elif Input.is_action_just_released("jump") or velocity.y >= 0:
			target_gravity = gravity_strong
	else:
		target_gravity = gravity_strong
	
	target_speed = direction * max_speed
	
	velocity.y += target_gravity
	velocity.x = lerp(velocity.x, target_speed, accel)
	if alive:
		velocity = move_and_slide(velocity, Vector2.UP)
	
	on_ground = ($RayCastLeft.is_colliding() or $RayCastRight.is_colliding() or is_on_floor())
	if on_ground:
		air_time = 0.0
	elif air_time < coyote_time:
		air_time += delta

func create_jump_effect():
	var jump_effect = preload("res://Scenes/Objects/Effect.tscn").instance()
	jump_effect.position = self.global_position
	jump_effect.play("player_jump")
	get_parent().add_child(jump_effect)

func win():
	emit_signal("win")

func checkpoint(body):
	emit_signal("checkpoint", body)

func death():
	alive = false
	$Sprite.visible = false
	$Effector/EffectorCollider.disabled = true
	$DeathParticles.emitting = true
	$DeathTimer.start()
	$Sounds/Death.play()
	
	emit_signal("die")

func respawn():
	alive = true
	$Sprite.visible = true
	$Effector/EffectorCollider.disabled = false
	$Sounds/Respawn.play()
	
	velocity = Vector2(0.0, -100.0)
	emit_signal("respawn")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "jump" or anim_name == "fall":
		Animator.stop()

func _on_Effector_body_entered(body):
	if body.get_collision_layer_bit(1):
		call_deferred("death")
	elif body.get_collision_layer_bit(2):
		call_deferred("checkpoint", body)
	elif body.get_collision_layer_bit(3):
		call_deferred("win")

func _on_DeathTimer_timeout():
	respawn()

func _on_ControlsUI_control_placed(control_type):
	match control_type:
		Controls.JUMP:
			jump_control = false
		Controls.LEFT:
			left_control = false
		Controls.RIGHT:
			right_control = false

func _on_ControlsUI_control_retrieved(control_type):
	match control_type:
		Controls.JUMP:
			jump_control = true
		Controls.LEFT:
			left_control = true
		Controls.RIGHT:
			right_control = true
