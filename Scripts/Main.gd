extends Node2D

# Menu navigation
onready var StartButton = $MainMenu/MainMenuContainer/CenterContainer/VBoxContainer/Start
onready var QuitButton = $MainMenu/MainMenuContainer/CenterContainer2/Quit
onready var OptionsButton = $MainMenu/MainMenuContainer/CenterContainer/VBoxContainer/HBoxContainer/Options
onready var CreditsButton = $MainMenu/MainMenuContainer/CenterContainer/VBoxContainer/HBoxContainer/Credits
onready var OptionsBackButton = $Options/VBoxContainer2/MarginContainer/HBoxContainer/OptionsBack
onready var CreditsBackButton = $Credits/VBoxContainer/MarginContainer/HBoxContainer/CreditsBack
# Sound options
onready var SFXSlider = $Options/VBoxContainer2/CenterContainer/VBoxContainer/Sound/SFX/SFXSlider
onready var SFXLabel = $Options/VBoxContainer2/CenterContainer/VBoxContainer/Sound/SFX/Number
onready var MusicSlider = $Options/VBoxContainer2/CenterContainer/VBoxContainer/Sound/Music/MusicSlider
onready var MusicLabel = $Options/VBoxContainer2/CenterContainer/VBoxContainer/Sound/Music/Number
# Display options
onready var FullscreenCheckButton = $Options/VBoxContainer2/CenterContainer/VBoxContainer/Display/Fullscreen/FullscreenCheckButton

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
	
	if OS.has_feature("HTML5"):
		QuitButton.hide()

func _input(event):
	if event.is_action_pressed("fullscreen"):
		yield(get_tree(), "idle_frame")
		FullscreenCheckButton.pressed = OS.window_fullscreen

func set_slider(slider: Node, label: Node, value: float):
	if slider.value != value:
		slider.value = value
	label.text = str(value*100)

func _on_Start_pressed():
	Global.set_transition()
	Global.goto_scene("res://Scenes/Worlds/World0.tscn")

func _on_Quit_pressed():
	get_tree().quit()

func _on_Options_pressed():
	$AnimationPlayer.play("goto_options")
	OptionsBackButton.grab_focus()

func _on_Credits_pressed():
	$AnimationPlayer.play("goto_credits")
	CreditsBackButton.grab_focus()

func _on_OptionsBack_pressed():
	$AnimationPlayer.play("options_to_menu")
	StartButton.grab_focus()
	
func _on_CreditsBack_pressed():
	$AnimationPlayer.play("credits_to_menu")
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
