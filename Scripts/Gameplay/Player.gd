extends KinematicBody2D

signal died
signal respawned

enum {JUMP, LEFT, RIGHT}

export var effects: Dictionary = {
	"Jump": preload("res://Scenes/Visuals/Effects/JumpEffect.tscn"),
	"Land": preload("res://Scenes/Visuals/Effects/LandEffect.tscn"),
	"Death": null
}

export var controls_enabled = true
# Movement exports
export var max_speed = 120.0 # Player max speed in px/s
export var jump_force = 160.0
export var gravity = 310.0
export var gravity_strong = 650.0
export var accel = 12
# Buffers
export var air_buffer = 0.1
export var jump_buffer = 0.1

var velocity: Vector2 = Vector2.ZERO
var target_speed: float = 0.0
var target_gravity: float = gravity_strong

var air_time = air_buffer
var jump_time = jump_buffer
var on_ground: bool = false

onready var _Sprite = $Sprite
onready var _Collision = $Collider
onready var _AnimationTree: AnimationTree = $AnimationTree
onready var _StateMachine: AnimationNodeStateMachinePlayback  = _AnimationTree["parameters/playback"]

func _ready():
	Global.current_checkpoint = global_position

func _process(_delta):
	if target_speed < 0.0:
		_Sprite.flip_h = true
	elif target_speed > 0.0:
		_Sprite.flip_h = false
	
	# Animation states
	if on_ground:
		if target_speed != 0.0:
			_StateMachine.travel("run")
		else:
			_StateMachine.travel("idle")
	else:
		if velocity.y >= 0.0:
			_StateMachine.travel("fall")


func _physics_process(delta):
	# Get horizontal movement direction, if controls are enabled
	var dir = 0.0
	if controls_enabled:
		# Get the movement direction on the X axis.
		# right = 1, left = -1
		if Global.active_controls[Global.Controls.RIGHT] and Input.is_action_pressed("ui_right"):
			dir += 1
		if Global.active_controls[Global.Controls.LEFT] and Input.is_action_pressed("ui_left"):
			dir -= 1
	
	# Vertical movement
	if velocity.y > 0:
		target_gravity = gravity_strong
	velocity.y += target_gravity * delta
	# Horizontal Movement, with frame-independant lerping
	target_speed = dir * max_speed
	velocity.x = lerp(velocity.x, target_speed, 1 - exp(-accel * delta))
	
	# Apply velocity
	velocity = move_and_slide(velocity, Vector2.UP)
	
	var landed = is_on_floor() and not on_ground
	
	on_ground = is_on_floor()
	if on_ground:
		# Reset air time
		air_time = 0.0
	else:
		air_time = min(air_time + delta, air_buffer)
		jump_time = min(jump_time + delta, jump_buffer)
	
	if controls_enabled and (jump_time < jump_buffer and air_time < air_buffer):
		jump()
	elif landed:
		land()

func _unhandled_input(event: InputEvent) -> void:
	if Global.active_controls[Global.Controls.JUMP] and event.is_action_pressed("jump"):
		# Reset buffer time, check for air_time
		jump_time = 0
	
	elif event.is_action_released("jump"):
		target_gravity = gravity_strong

func jump():
	# Movement variables
	velocity.y = -jump_force
	target_gravity = gravity
	
	# Status variables
	jump_time = jump_buffer
	air_time = air_buffer
	on_ground = false
	
	# Animation and effects
	_StateMachine.travel("jump")
	Global.create_at(effects["Jump"], global_position, self)

func land():
	# Animation and effects
	Global.create_at(effects["Land"], global_position, self)

func die()->void:
	velocity = Vector2.ZERO
	# Status variables
	jump_time = jump_buffer
	air_time = air_buffer
	on_ground = false
	
	set_physics_process(false)
	_StateMachine.start("die")
	
	emit_signal("died")

func respawn():
	position = Global.current_checkpoint
	set_physics_process(true)
	
	emit_signal("respawned")

func _on_HazardsHitbox_body_entered(body):
	if _StateMachine.get_current_node() != "die":
		die()
