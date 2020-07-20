extends KinematicBody2D

signal start_drag
signal stop_drag
signal place_in_world(node)
signal retrieve_from_world(node)

enum Controls {JUMP, LEFT, RIGHT}
export(Controls) var control_type

enum {
	NORMAL, HOVER, 
	PRESSED, PRESSED_HOVER, 
	WORLD, WORLD_HOVER,
	DRAGGED,  DRAGGED_HOVER
}
var TILESIZE = 16

var hover = false
var valid_pos = true
var in_world = false
var dragged = false
var drag_time = 0.0
var limit_drag_time = 0.2

var shaking = false
var shake_amount: float
var shake_time: float
var elapsed_time: float

var Actions = ["jump", "left", "right"]
var control_action: String

var ControlSprite: Sprite
var Collider: CollisionShape2D
var GridMask: Light2D

# Called when the node enters the scene tree for the first time.
func _ready():
	ControlSprite = $Sprite
	Collider = $Collider
	GridMask = $GridMask
	
	connect("start_drag", self, "_on_start_drag")
	connect("stop_drag", self, "_on_stop_drag")
	
	control_action = Actions[control_type]
	randomize()

func _process(delta):
	if dragged:
		if hover:
			ControlSprite.frame = DRAGGED_HOVER
		else:
			ControlSprite.frame = DRAGGED
	elif in_world:
		if hover:
			ControlSprite.frame = WORLD_HOVER
		else:
			ControlSprite.frame = WORLD
	elif Input.is_action_pressed(control_action):
		if hover:
			ControlSprite.frame = PRESSED_HOVER
		else:
			ControlSprite.frame = PRESSED
	else:
		if hover:
			ControlSprite.frame = HOVER
		else:
			ControlSprite.frame = NORMAL
	
	if Input.is_action_just_pressed(control_action) and (dragged or in_world):
		var tween = $Tween
		tween.interpolate_property(ControlSprite, "modulate",
			Color(1.2, 0.0, 0.0),
			Color(1.0, 1.0, 1.0),
			0.2
		)
		tween.start()
		shake(2, 0.2)
	
	if not valid_pos:
		ControlSprite.modulate.a = 0.5
	else:
		ControlSprite.modulate.a = 1.0
	
	if shaking:
		_shake_process(delta)

func _physics_process(delta):
	valid_pos = true
	if dragged:
		drag_time += delta
		position = (get_global_mouse_position()-Vector2(8, 8)).snapped(Vector2.ONE*TILESIZE)
		if control_type == Controls.JUMP:
			position += Vector2(0, 8)
		else:
			position += Vector2(8, 8)
		if $Placement.get_overlapping_bodies().size() > 0:
			valid_pos = false

func _shake_process(delta):
	if elapsed_time > shake_time:
		shaking = false
		ControlSprite.offset = Vector2.ZERO
	else:
		ControlSprite.offset =  Vector2(randf(), randf()) * shake_amount
		elapsed_time += delta

func _on_start_drag():
	drag_time = 0.0
	dragged = true
	toggle_grid(true)
	Collider.disabled = true
	emit_signal("place_in_world", self)
	position = get_global_mouse_position().round()

func _on_stop_drag():
	dragged = false
	toggle_grid(false)
	if valid_pos and drag_time > limit_drag_time:
		Collider.disabled = false
		if !in_world:
			in_world = true
	else:
		emit_signal("retrieve_from_world", self)

func toggle_grid(state):
	var animator = $AnimationGrid
	if state:
		animator.current_animation = "show_grid"
	else:
		animator.current_animation = "hide_grid"
	animator.playback_active = true
		
func retrieve():
	in_world = false
	Collider.disabled = true
	hover = false
	ControlSprite.modulate = Color(1.0, 1.0, 1.0)

func shake(amount: float, time: float):
	shake_amount = amount
	shake_time = time
	elapsed_time = 0.0
	shaking = true

func _on_Control_mouse_entered():
	hover = true

func _on_Control_mouse_exited():
	hover = false

func _on_Control_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			emit_signal("start_drag")

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and !event.pressed and dragged:
			emit_signal("stop_drag")

