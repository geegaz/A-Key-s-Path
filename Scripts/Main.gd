extends Node2D

# Screens
onready var Options = $Options
onready var Credits = $Credits
onready var MainMenu = $MainMenu
onready var Levels = $Levels
# Menu navigation
onready var StartButton = $MainMenu/MainMenuContainer/CenterContainer/VBoxContainer/Start
onready var QuitButton = $MainMenu/MainMenuContainer/CenterContainer2/Quit
onready var OptionsButton = $MainMenu/MainMenuContainer/CenterContainer/VBoxContainer/HBoxContainer/Options
onready var CreditsButton = $MainMenu/MainMenuContainer/CenterContainer/VBoxContainer/HBoxContainer/Credits
onready var OptionsBackButton = $Options/VBoxContainer2/MarginContainer/HBoxContainer/OptionsBack
onready var CreditsBackButton = $Credits/VBoxContainer/MarginContainer/HBoxContainer/CreditsBack
onready var LevelsBackButton = $Levels/VBoxContainer/CenterContainer/LevelsBack
# Sound options
onready var SFXSlider = $Options/VBoxContainer2/CenterContainer/VBoxContainer/Sound/SFX/SFXSlider
onready var SFXLabel = $Options/VBoxContainer2/CenterContainer/VBoxContainer/Sound/SFX/Number
onready var MusicSlider = $Options/VBoxContainer2/CenterContainer/VBoxContainer/Sound/Music/MusicSlider
onready var MusicLabel = $Options/VBoxContainer2/CenterContainer/VBoxContainer/Sound/Music/Number
# Display options
onready var FullscreenCheckButton = $Options/VBoxContainer2/CenterContainer/VBoxContainer/Display/FullscreenCheckButton
onready var ScreenshakeCheckButton = $Options/VBoxContainer2/CenterContainer/VBoxContainer/Display/ScreenshakeCheckButton

# Level variables
export(Array, NodePath) var LevelButtons
export(Array, String, FILE, "*.tscn") var LevelPaths

# Called when the node enters the scene tree for the first time.
func _ready():
	StartButton.grab_focus()
	
	set_slider(
		SFXSlider,
		SFXLabel,
		Global.sfx_volume
	)
	set_slider(
		MusicSlider,
		MusicLabel,
		Global.music_volume
	)
	
	FullscreenCheckButton.pressed = OS.window_fullscreen
	ScreenshakeCheckButton.pressed = Global.screenshake
	
	unlock_levels()
	
	if Global.show_levels:
		$Camera2D.position = Vector2(160,-96)
		LevelsBackButton.grab_focus()
		Global.show_levels = false
	
	if OS.has_feature("HTML5"):
		QuitButton.hide()

func _input(event):
	if event.is_action_pressed("fullscreen"):
		yield(get_tree(), "idle_frame")
		FullscreenCheckButton.pressed = OS.window_fullscreen
	if event.is_action_pressed("quit"):
		$QuitConfirmationDialog.call_deferred("show_modal")

func set_slider(slider: Node, label: Node, value: float):
	if slider.value != value:
		slider.value = value
	label.text = str(value*100)

func change_screen(pos: Vector2):
	var tween = $Tween
	if !tween.is_active():
		tween.interpolate_property($Camera2D, "position",
			$Camera2D.position, pos, 0.2)
		tween.start()
		
func unlock_levels():
	for i in range(LevelButtons.size()):
		var _button = get_node(LevelButtons[i])
		if i > Global.max_unlocked_level:
			_button.disabled = true
		if i < LevelPaths.size():
			_button.connect("pressed", self, "_on_LevelButton_pressed", [LevelPaths[i]])

func _on_Start_pressed():
	change_screen(Vector2(160,-96))
	LevelsBackButton.grab_focus()

func _on_Quit_pressed():
	$QuitConfirmationDialog.show_modal()

func _on_Options_pressed():
	change_screen(Vector2(-160,92))
	OptionsBackButton.grab_focus()

func _on_Credits_pressed():
	change_screen(Vector2(480,92))
	CreditsBackButton.grab_focus()

func _on_OptionsBack_pressed():
	change_screen(Vector2(160,92))
	StartButton.grab_focus()
	
func _on_CreditsBack_pressed():
	change_screen(Vector2(160,92))
	StartButton.grab_focus()

func _on_LevelsBack_pressed():
	change_screen(Vector2(160,92))
	StartButton.grab_focus()

func _on_SFXSlider_value_changed(value):
	set_slider(
		SFXSlider,
		SFXLabel,
		value
	)
	Global.set_volume(Global.SFX, value)

func _on_MusicSlider_value_changed(value):
	set_slider(
		MusicSlider,
		MusicLabel,
		value
	)
	Global.set_volume(Global.MUSIC, value)

func _on_CheckButton_toggled(button_pressed):
	OS.window_fullscreen = button_pressed

func _on_ScreenshakeCheckButton_toggled(button_pressed):
	Global.screenshake = button_pressed

func _on_LevelButton_pressed(level_path: String = "menu"):
	print(level_path)
	Global.set_transition()
	Global.goto_scene(level_path)

func _on_QuitConfirmationDialog_confirmed():
	get_tree().quit()
