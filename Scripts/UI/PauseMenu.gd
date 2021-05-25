extends Control

export(NodePath) var options_menu_path
onready var _OptionsMenu = get_node_or_null(options_menu_path)

export(NodePath) var option_path = "CenterContainer/VBoxContainer/Options"

func _ready():
	pause(get_tree().paused)
	if _OptionsMenu:
		get_node(option_path).show()
		_OptionsMenu

func _input(event):
	if event.is_action_pressed("quit"):
		if _OptionsMenu and _OptionsMenu.visible:
			_OptionsMenu.back()
		else:
			pause(!get_tree().paused)

func pause(state: bool):
	self.visible = state
	get_tree().paused = state


func _on_Continue_pressed():
	pause(false)

func _on_BackToMenu_pressed():
	pause(false)
	Global.transition_to_scene("res://Scenes/Main.tscn")


func _on_Options_pressed():
	if _OptionsMenu:
		_OptionsMenu.show()
		self.hide()
