extends KinematicBody2D

signal place(control_type)
signal retrieve(control_type)

export(Global.Controls) var control_type

enum {
	NORMAL, 
	PRESSED,
	WORLD,
	DRAGGED,
}
var TILESIZE: = Vector2(16, 16)

var hover: = false
var valid_pos: = true
var in_world: = false
var dragged: = false
var drag_time = 0.0
var limit_drag_time = 0.2

var Actions = ["jump", "ui_left", "ui_right"]
onready var control_action: String = Actions[control_type]

onready var _Sprite: Sprite = $Sprite
onready var _Collider: CollisionShape2D = $Collider
onready var _Placement: Control = $Placement

# Called when the node enters the scene tree for the first time.
func _ready():
	_Placement.connect("mouse_entered", self, "_on_Placement_mouse_entered")
	_Placement.connect("mouse_exited", self, "_on_Placement_mouse_exited")
	_Placement.connect("gui_input", self, "_on_Placement_gui_input")

func _process(delta):
	# Sprite appearance
	if dragged:
		_Sprite.frame = DRAGGED
	elif in_world:
		_Sprite.frame = WORLD
	elif Input.is_action_pressed(control_action):
		_Sprite.frame = PRESSED
	else:
		_Sprite.frame = NORMAL
	_Sprite.frame *= 2
	
	# Drag management
	if dragged:
		drag_time += delta
		# ControlBlock movement
		var displacement: Vector2 = TILESIZE/2
		if control_type == Global.Controls.JUMP:
			displacement = Vector2.UP * TILESIZE/2
		position = (get_global_mouse_position() - displacement).snapped(TILESIZE) + displacement
		
		if not Input.is_mouse_button_pressed(BUTTON_LEFT):
			stop_drag()
	
	elif hover:
		_Sprite.frame += 1
	
	modulate.a = 1.0 if valid_pos else 0.5
	modulate = lerp(modulate, Color.white, delta * 4)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(control_action) and (dragged or in_world):
		modulate = Color.red * 2
		Global._Shaker.add_shake(_Sprite, "offset", Vector2(1,16), 0.2, 2.0)

func _physics_process(delta):
	valid_pos = true
	if dragged and $PlacementArea.get_overlapping_bodies().size() > 0:
		valid_pos = false

func start_drag():
	drag_time = 0.0
	dragged = true
	_Collider.disabled = true
	z_index = 1
	
	emit_signal("place", self.control_type)
#	position = get_global_mouse_position().round()

func stop_drag():
	dragged = false
	if valid_pos and drag_time > limit_drag_time:
		_Collider.disabled = false
		if !in_world:
			in_world = true
		z_index = 0
	else:
		emit_signal("retrieve", self.control_type)
		
func retrieve():
	in_world = false
	_Collider.disabled = true
	hover = false
	z_index = 1
	_Sprite.modulate = Color.white

func _on_Placement_mouse_entered():
	hover = true

func _on_Placement_mouse_exited():
	hover = false

func _on_Placement_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass

func _on_Placement_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			start_drag()
