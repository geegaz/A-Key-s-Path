tool
extends Control

export(String) var world_name: String = "World" setget set_world_name
export(int) var world_id: int = 0
export(Array, String, FILE, "*.tscn") var levels_paths setget set_levels_paths

var levels_container_path = "VBoxContainer/Levels"
var world_name_path = "VBoxContainer/WorldName"

export(Array, Texture) var button_textures = [
	preload("res://Assets/Theme/resources/level_button/disabled.tres"),
	preload("res://Assets/Theme/resources/level_button/hover.tres"),
	preload("res://Assets/Theme/resources/level_button/normal.tres"),
	preload("res://Assets/Theme/resources/level_button/pressed.tres")
]
export(Array, Texture) var big_button_textures = [
	preload("res://Assets/Theme/resources/level_button/big_disabled.tres"),
	preload("res://Assets/Theme/resources/level_button/big_hover.tres"),
	preload("res://Assets/Theme/resources/level_button/big_normal.tres"),
	preload("res://Assets/Theme/resources/level_button/big_pressed.tres")
]
enum {DISABLED, HOVER, NORMAL, PRESSED, FOCUSED}

var level_buttons: Array = []

func _ready():
	unlock_levels()

func set_world_name(new_name: String):
	var _WorldName = get_node_or_null(world_name_path)
	if _WorldName:
		_WorldName.text = new_name
	
	world_name = new_name

func set_levels_paths(new_array: Array):
	var _Levels = get_node_or_null(levels_container_path)
	if _Levels:
		level_buttons = []
		for old_button in _Levels.get_children():
			old_button.queue_free()
		for i in new_array.size():
			var big = (i == new_array.size()-1)
			var new_button = make_button(big)
			new_button.name = "Level %s"%i
			new_button.connect("pressed", self, "_on_LevelButton_pressed", [new_array[i]])
			
			_Levels.add_child(new_button)
			level_buttons.append(new_button)
	
	levels_paths = new_array

func make_button(big: bool = false)->TextureButton:
	var button = TextureButton.new()
	var textures_source: Array
	if big:
		textures_source = big_button_textures
	else:
		textures_source = button_textures
	
	button.texture_normal = textures_source[NORMAL]
	button.texture_hover = textures_source[HOVER]
	button.texture_pressed = textures_source[PRESSED]
	button.texture_disabled = textures_source[DISABLED]
	
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.size_flags_vertical = SIZE_SHRINK_CENTER
	
	return button

func unlock_levels():
	for i in range(level_buttons.size()):
		var button: BaseButton = level_buttons[i]
		if i > Global.world_unlocked_levels[world_id]:
			button.disabled = true
			button.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _on_LevelButton_pressed(level: String):
	Global.transition_to_scene(level)
