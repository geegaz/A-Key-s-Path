extends KinematicBody2D

signal place(control_type)
signal retrieve(control_type)

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

var Actions = ["jump", "ui_left", "ui_right"]
var control_action: String

onready var ControlSprite: Sprite = $Sprite
onready var Collider: CollisionShape2D = $Collider
onready var GridMask: Light2D = $GridMask
onready var InputControl: Control = $Control

# Called when the node enters the scene tree for the first time.
func _ready():
	control_action = Actions[control_type]

func _process(_delta):
	if dragged:
#		if hover:
#			ControlSprite.frame = DRAGGED_HOVER
#		else:
#			ControlSprite.frame = DRAGGED
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
			Color(1.5, 1.5, 1.5),
			Color(1.0, 1.0, 1.0),
			0.2
		)
		tween.start()
		$Shaker.shake(ControlSprite, "offset", 2.0, 0.2)
	
	if dragged and not valid_pos:
		ControlSprite.modulate.a = 0.5
	else:
		ControlSprite.modulate.a = 1.0

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

func start_drag():
	drag_time = 0.0
	dragged = true
	toggle_grid(true)
	Collider.disabled = true
	z_index = 1
	
	emit_signal("place", self.control_type)
	position = get_global_mouse_position().round()

func stop_drag():
	dragged = false
	toggle_grid(false)
	if valid_pos and drag_time > limit_drag_time:
		Collider.disabled = false
		if !in_world:
			in_world = true
		z_index = 0
	else:
		emit_signal("retrieve", self.control_type)

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
	z_index = 1
	ControlSprite.modulate = Color(1.0, 1.0, 1.0)

func _on_Control_mouse_entered():
	hover = true

func _on_Control_mouse_exited():
	hover = false

func _on_Control_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			start_drag()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and !event.pressed and dragged:
			stop_drag()

