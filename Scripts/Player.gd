extends KinematicBody2D

signal checkpoint
signal death

enum {IDLE, RUNNING, JUMPING, FALLING}
var state = IDLE

export var max_speed = 75.0
export var jump_force = 75.0
export var gravity = 2.0
export var accel = 0.1

var left_control = true
var right_control = true
var jump_control = true
var on_ground = false

var velocity = Vector2()
var target_speed = 0.0

var Animator: AnimationPlayer

func _ready():
	Animator = $AnimationPlayer

func _process(delta):
	var direction = 0.0
	if left_control and Input.is_action_pressed("ui_left"):
		direction -= 1.0
	if right_control and Input.is_action_pressed("ui_right"):
		direction += 1.0
	if jump_control and Input.is_action_just_pressed("ui_select") and on_ground:
		velocity.y -= jump_force
	
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
	velocity.y += gravity
	velocity.x = lerp(velocity.x, target_speed, accel)
	
	velocity = move_and_slide(velocity, Vector2.UP)
	on_ground = ($RayCastLeft.is_colliding() or $RayCastRight.is_colliding())

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "jump" or anim_name == "fall":
		Animator.stop()


func _on_Effector_body_entered(body):
	pass # Replace with function body.
