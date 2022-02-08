extends KinematicBody2D


enum {
	NORMAL,
	PRESSED = 2,
	WORLD_NORMAL = 4,
	WORLD_PRESSED = 6
}
var in_world: = false
var dragged: = false
var hover: = false

onready var _Sprite = $Sprite

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if in_world:
		if dragged:
			_Sprite.frame = WORLD_PRESSED
		else:
			_Sprite.frame = WORLD_NORMAL
	else:
		if dragged:
			_Sprite.frame = PRESSED
		else:
			_Sprite.frame = NORMAL
	
	if hover:
		_Sprite.frame += 1


func _on_DragBlock_mouse_entered() -> void:
	hover = true

func _on_DragBlock_mouse_exited() -> void:
	hover = false


func _on_DragBlock_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			pass

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and !event.pressed and dragged:
			pass
