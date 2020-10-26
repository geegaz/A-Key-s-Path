extends KinematicBody2D

signal checkpoint(node)
signal die
signal respawn
signal win

enum Controls {JUMP, LEFT, RIGHT}
enum States {IDLE, RUNNING, JUMPING, FALLING}
var state = States.IDLE

# Movement exports
export var max_speed = 120.0		# Player max speed in px/s
export var jump_force = 160.0
export var gravity = 310.0
export var gravity_strong = 650.0
export var accel = 0.3
export var coyote_time = 0.1

var velocity = Vector2()
var target_speed = 0.0
var target_gravity: float

var air_time = 0.0
var on_ground = false

var left_control = true
var right_control = true
var jump_control = true

var controls_enabled = true
var movement_enabled = true
var animations_enabled = true

onready var _PlayerSprite = $PlayerSprite
onready var _RayCastLeft = $RayCastLeft
onready var _RayCastRight = $RayCastRight

func _ready():
	target_gravity = gravity_strong
	randomize()

func _process(_delta):
	if target_speed < 0.0:
		_PlayerSprite.flip_h = true
	elif target_speed > 0.0:
		_PlayerSprite.flip_h = false
	
	if animations_enabled:
		if on_ground:
			if abs(target_speed) > 0.0:
				set_state(States.RUNNING)
			else:
				set_state(States.IDLE)
		else:
			if velocity.y > 0.0:
				set_state(States.FALLING)
			else:
				set_state(States.JUMPING)
	
	if state != States.RUNNING and $Sounds/Running.playing:
		$Sounds/Running.stop()

func _physics_process(delta):
	var direction = 0.0
	if controls_enabled and movement_enabled:
		# Get the movement direction on the X axis. 
		# right = 1, left = -1
		if right_control and Input.is_action_pressed("right"):
			direction += 1
		if left_control and Input.is_action_pressed("left"):
			direction -= 1
	
	target_speed = direction * max_speed
	
	if movement_enabled:
		if velocity.y >= 0:
			target_gravity = gravity_strong
		velocity.y += target_gravity*delta
		velocity.x = lerp(velocity.x, target_speed, accel)
		
		velocity = move_and_slide(velocity, Vector2.UP)
		
		on_ground = ((_RayCastLeft.is_colliding() or _RayCastRight.is_colliding() or is_on_floor()) and velocity.y >= 0.0)
		if on_ground:
			air_time = 0.0
		elif air_time < coyote_time:
			air_time += delta

func _input(event):
	if event.is_action_pressed("jump") and jump_control:
		if air_time < coyote_time:
			velocity.y = -jump_force
			target_gravity = gravity
			air_time = coyote_time
			
			$Sounds/Jump.pitch_scale = (randf()*0.8+0.6)
			$Sounds/Jump.play()
			create_jump_effect()
	
	elif event.is_action_released("jump"):
		target_gravity = gravity_strong

func create_jump_effect():
	var jump_effect = preload("res://Scenes/Objects/Effect.tscn").instance()
	jump_effect.position = self.global_position
	jump_effect.play("player_jump")
	get_parent().add_child(jump_effect)

func set_state(new_state):
	if new_state != state:
		state = new_state
		match new_state:
			States.IDLE:
				_PlayerSprite.play("Idle")
			States.RUNNING:
				_PlayerSprite.play("Run")
				$Sounds/Running.play()
			States.JUMPING:
				_PlayerSprite.play("Jump")
			States.FALLING:
				_PlayerSprite.play("Fall")

func win():
	emit_signal("win")

func checkpoint(body):
	emit_signal("checkpoint", body)

func death():
	movement_enabled = false
	_PlayerSprite.visible = false
	$Effector/EffectorCollider.disabled = true
	$DeathParticles.emitting = true
	$Sounds/Death.play()
	
	$DeathTimer.start()
	
	emit_signal("die")

func respawn():
	movement_enabled = true
	_PlayerSprite.visible = true
	$Effector/EffectorCollider.disabled = false
	$Sounds/Respawn.play()
	
	velocity = Vector2(0.0, -100.0)
	emit_signal("respawn")

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
