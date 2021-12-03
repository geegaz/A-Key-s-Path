extends Control


onready var _Sliders = [
	$ScrollContainer/CenterContainer/VBoxContainer/Sound/Master/MasterSlider, # Master slider
	$ScrollContainer/CenterContainer/VBoxContainer/Sound/SFX/SFXSlider, # SFX slider
	$ScrollContainer/CenterContainer/VBoxContainer/Sound/Music/MusicSlider, # Music slider
]
onready var _Fullscreen = $ScrollContainer/CenterContainer/VBoxContainer/Display/FullscreenCheckButton
onready var _Screenshake = $ScrollContainer/CenterContainer/VBoxContainer/Display/ScreenshakeCheckButton

# 0, 1, 2 -> Bus == node_path index
enum {MASTER, SFX, MUSIC}

# Called when the node enters the scene tree for the first time.
func _ready():
	for bus in range(3):
		_Sliders[bus].value = Global.volumes[bus]
	_Fullscreen.pressed = Global.fullscreen
	_Screenshake.pressed = Global.screenshake

func _on_MasterSlider_value_changed(value):
	Global.volumes[MASTER] = value
	
func _on_SFXSlider_value_changed(value):
	Global.volumes[SFX] = value

func _on_MusicSlider_value_changed(value):
	Global.volumes[MUSIC] = value

func _on_FullscreenCheckButton_toggled(button_pressed):
	Global.fullscreen = button_pressed

func _on_ScreenshakeCheckButton_toggled(button_pressed):
	Global.screenshake = button_pressed
