extends KinematicBody2D

export var max_speed = 75.0
export var jump_force = 75.0
export var gravity = 2.0
export var accel = 0.1

var left_control = true
var right_control = true
var jump_control = true

var velocity = Vector2()
var target_speed = 0.0

var on_ground = false

var CastLeft: RayCast2D
var CastRight: RayCast2D

func _ready():
	CastLeft = $CastLeft
	CastRight = $CastRight

func _process(delta):
	var on_ground = (CastLeft.is_colliding() or CastRight.is_colliding())
	var direction = 0.0
	if left_control and Input.is_action_pressed("ui_left"):
		direction -= 1.0
	if right_control and Input.is_action_pressed("ui_right"):
		direction += 1.0
	if jump_control and Input.is_action_just_pressed("ui_select") and on_ground:
		velocity.y -= jump_force
	
	target_speed = direction * max_speed
	

func _physics_process(delta):
	velocity.y += gravity
	velocity.x = lerp(velocity.x, target_speed, accel)
	
	var collision = move_and_collide(velocity*delta)
	if collision:
		velocity = velocity.slide(collision.normal)
