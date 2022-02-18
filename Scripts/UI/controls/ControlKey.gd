extends KinematicBody2D

signal dragged
signal placed
signal retrieved

export(Global.Controls) var control_type

enum {
	NORMAL, 
	PRESSED,
	WORLD,
	DRAGGED,
}
var TILESIZE: = Vector2(16, 16)

var valid_pos: = true
var in_world: = false

var hover: = false
var dragged: = false
var drag_time = 0.0
var limit_drag_time = 0.2

var Actions = ["jump", "ui_left", "ui_right"]
onready var control_action: String = Actions[control_type]

onready var _Sprite: = $Sprite
onready var _Collider: = $Collider
onready var _Placement: = $Placement

onready var displacement: = Vector2.UP * TILESIZE/2 if control_type == Global.Controls.JUMP else TILESIZE/2

# Called when the node enters the scene tree for the first time.
func _ready():
	_Placement.connect("mouse_entered", self, "_on_Placement_mouse_entered")
	_Placement.connect("mouse_exited", self, "_on_Placement_mouse_exited")
	_Placement.connect("gui_input", self, "_on_Placement_gui_input")

func _process(delta):
	# Sprite appearance
	if dragged:
		_Sprite.frame = DRAGGED
		drag_time += delta
		
	elif in_world:
		_Sprite.frame = WORLD
	elif Input.is_action_pressed(control_action):
		_Sprite.frame = PRESSED
	else:
		_Sprite.frame = NORMAL
	_Sprite.frame *= 2
	
	if dragged:
		# ControlBlock movement
		position = get_position_snapped(get_global_mouse_position())
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
	if dragged:
		collision_mask = 21
		valid_pos = not test_move(Transform2D(0, get_absolute_world_position(position) + Vector2.DOWN), Vector2.UP)
	
	collision_mask = 0

func start_drag():
	drag_time = 0.0
	dragged = true
	
	emit_signal("dragged")

func stop_drag():
	dragged = false
	# Positioning & placement
	position = get_position_snapped(position)
	if valid_pos and drag_time > limit_drag_time:
		emit_signal("placed")
	else:
		position = get_absolute_world_position(position)
		emit_signal("retrieved")

func get_absolute_world_position(pos: Vector2)-> Vector2:
	return get_viewport().canvas_transform.xform_inv(pos)

func get_absolute_local_position(pos: Vector2)-> Vector2:
	return get_viewport().canvas_transform.xform(pos)

func get_position_snapped(pos: Vector2)->Vector2:
	var target_pos: Vector2 = (get_absolute_world_position(pos) - displacement).snapped(TILESIZE)
	return get_absolute_local_position(target_pos) + displacement

func set_physical(value: bool):
	_Sprite.modulate = Color.white
	# Set collision
	in_world = value
	set_collision_layer_bit(0, value)
	_Collider.set_deferred("disabled", not value)

func _on_Placement_mouse_entered():
	hover = true

func _on_Placement_mouse_exited():
	hover = false

func _on_Placement_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			start_drag()
