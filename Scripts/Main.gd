extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu/MainMenuContainer/CenterContainer/VBoxContainer/Start.grab_focus()
	set_slider(
		$Options/VBoxContainer2/CenterContainer/VBoxContainer/VBoxContainer/SoundsSFX/SFXSlider,
		$Options/VBoxContainer2/CenterContainer/VBoxContainer/VBoxContainer/SoundsSFX/Number,
		Global.sfx_volume
	)
	set_slider(
		$Options/VBoxContainer2/CenterContainer/VBoxContainer/VBoxContainer/SoundsMusic/MusicSlider,
		$Options/VBoxContainer2/CenterContainer/VBoxContainer/VBoxContainer/SoundsMusic/Number,
		Global.music_volume
	)

func set_slider(slider: Node, label: Node, value: float):
	if slider.value != value:
		slider.value = value
	label.text = str(value*100)

func _on_Start_pressed():
	Global.set_transition()
	Global.goto_scene("res://Scenes/Worlds/World1.tscn")

func _on_Quit_pressed():
	get_tree().quit()


func _on_Options_pressed():
	$AnimationPlayer.play("goto_options")
	$Options/VBoxContainer2/MarginContainer/HBoxContainer/OptionsBack.grab_focus()

func _on_Credits_pressed():
	$AnimationPlayer.play("goto_credits")
	$Credits/VBoxContainer/MarginContainer/HBoxContainer/CreditsBack.grab_focus()

func _on_OptionsBack_pressed():
	$AnimationPlayer.play("options_to_menu")
	$MainMenu/MainMenuContainer/CenterContainer/VBoxContainer/Start.grab_focus()
	
func _on_CreditsBack_pressed():
	$AnimationPlayer.play("credits_to_menu")
	$MainMenu/MainMenuContainer/CenterContainer/VBoxContainer/Start.grab_focus()


func _on_SFXSlider_value_changed(value):
	set_slider(
		$Options/VBoxContainer2/CenterContainer/VBoxContainer/VBoxContainer/SoundsSFX/SFXSlider,
		$Options/VBoxContainer2/CenterContainer/VBoxContainer/VBoxContainer/SoundsSFX/Number,
		value
	)
	Global.set_volume(Global.SFX, value)

func _on_MusicSlider_value_changed(value):
	set_slider(
		$Options/VBoxContainer2/CenterContainer/VBoxContainer/VBoxContainer/SoundsMusic/MusicSlider,
		$Options/VBoxContainer2/CenterContainer/VBoxContainer/VBoxContainer/SoundsMusic/Number,
		value
	)
	Global.set_volume(Global.MUSIC, value)
