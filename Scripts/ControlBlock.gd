extends KinematicBody2D

signal start_drag
signal stop_drag
signal place_in_world(node)
signal retrieve_from_world(node)

enum Controls {JUMP, LEFT, RIGHT}
export(Controls) var control_type

enum {NORMAL, HOVER, PRESSED, PRESSED_HOVER}

var hover = false
var dragged = false
var drag_time = 0.0
var limit_drag_time = 0.2

var valid_pos = true
var in_world = false

var control_action: String

var ControlSprite: Sprite
var Collider: CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready():
	ControlSprite = $Sprite
	Collider = $Collider
	
	connect("start_drag", self, "_on_start_drag")
	connect("stop_drag", self, "_on_stop_drag")
	
	match control_type:
		Controls.JUMP:
			control_action = "jump"
		Controls.LEFT:
			control_action = "left"
		Controls.RIGHT:
			control_action = "right"

func _process(delta):
	if Input.is_action_pressed(control_action) or dragged or in_world:
		if hover:
			ControlSprite.frame = PRESSED_HOVER
		else:
			ControlSprite.frame = PRESSED
	else:
		if hover:
			ControlSprite.frame = HOVER
		else:
			ControlSprite.frame = NORMAL
	
	if Input.is_action_just_pressed(control_action) and in_world:
		var tween = $Tween
		tween.interpolate_property(ControlSprite, "modulate", 
			Color(1.0, 0.0, 0.0),
			Color(1.0, 1.0, 1.0),
			0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
	
	
	if not valid_pos:
		ControlSprite.modulate.a = 0.5
	else:
		ControlSprite.modulate.a = 1.0

func _physics_process(delta):
	valid_pos = true
	if dragged:
		drag_time += delta
		position = get_global_mouse_position().round()
		if $Area2D.get_overlapping_bodies().size() > 0:
			valid_pos = false

func _on_start_drag():
	drag_time = 0.0
	dragged = true
	if not in_world:
		Collider.disabled = true
		emit_signal("place_in_world", self)
		position = get_global_mouse_position().round()
	else:
		emit_signal("retrieve_from_world", self)

func _on_stop_drag():
	dragged = false
	if valid_pos and drag_time > limit_drag_time:
		in_world = true
		Collider.disabled = false
	else:
		emit_signal("retrieve_from_world", self)

func retrieve():
	in_world = false
	Collider.disabled = true
	hover = false
	ControlSprite.modulate = Color(1.0, 1.0, 1.0)
	

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
		if event.button_index == BUTTON_LEFT and !event.pressed:
			emit_signal("stop_drag")

