extends KinematicBody2D

enum {JUMP, LEFT, RIGHT}

# Movement exports
export var max_speed = 120.0		# Player max speed in px/s
export var jump_force = 160.0
export var gravity = 310.0
export var gravity_strong = 650.0
export var accel = 0.3
export var coyote_time = 0.1
export var jump_buffer = 0.1

var velocity: Vector2 = Vector2.ZERO
var target_speed: float = 0.0
var target_gravity: float

var air_time = 0.0
var buffer_time = 0.0
var on_ground: bool = false

var left_control: bool = true
var right_control: bool = true
var jump_control: bool = true

var controls_enabled = true

onready var _PlayerSprite = $Sprite
onready var _CutsceneStateMachine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]
onready var _MoveStateMachine: AnimationNodeStateMachinePlayback  = $AnimationTree["parameters/MoveState/playback"]

func _ready():
	target_gravity = gravity_strong

func _process(_delta):
	if target_speed < 0.0:
		_PlayerSprite.flip_h = true
	elif target_speed > 0.0:
		_PlayerSprite.flip_h = false
	
	# Animation states
	if on_ground:
		if target_speed != 0.0:
			_MoveStateMachine.travel("run")
		else:
			_MoveStateMachine.travel("idle")
	else:
		if velocity.y > 0.0:
			_MoveStateMachine.travel("fall")
		

func _physics_process(delta):
	# Get horizontal movement direction, if controls are enabled
	var dir = 0.0
	if controls_enabled:
		# Get the movement direction on the X axis. 
		# right = 1, left = -1
		if right_control and Input.is_action_pressed("right"):
			dir += 1
		if left_control and Input.is_action_pressed("left"):
			dir -= 1
	
	# Vertical movement
	if velocity.y >= 0:
		target_gravity = gravity_strong
	velocity.y += target_gravity*delta
	# Horizontal Movement
	target_speed = dir * max_speed
	velocity.x = lerp(velocity.x, target_speed, accel)
	
	# Apply velocity
	velocity = move_and_slide(velocity, Vector2.UP)
	
	on_ground = is_on_floor()
	
	if on_ground:
		# Reset air time, check for buffer time
		air_time = 0.0
		if buffer_time > 0:
			jump()
	else:
		if air_time < coyote_time:
			air_time += delta
		if buffer_time > 0:
			buffer_time -= delta

func _input(event):
	if event.is_action_pressed("jump") and jump_control:
		# Reset buffer time, check for air_time
		buffer_time = jump_buffer
		if air_time < coyote_time:
			jump()
	
	elif event.is_action_released("jump"):
		target_gravity = gravity_strong

func jump():
	# Movement variables
	velocity.y = -jump_force
	target_gravity = gravity
	
	# Status variables
	buffer_time = 0.0
	air_time = coyote_time
	on_ground = false
	
	# Animation and effects
	_MoveStateMachine.travel("jump")
	create_jump_effect()

func create_jump_effect():
	var jump_effect = preload("res://Scenes/Objects/Effect.tscn").instance()
	jump_effect.position = self.global_position
	jump_effect.play("player_jump")
	get_parent().add_child(jump_effect)
