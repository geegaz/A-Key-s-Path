extends Control

# 0, 1, 2 -> Bus == node_path index
enum {MASTER, SFX, MUSIC}

onready var _Sliders = [
	$ScrollContainer/CenterContainer/VBoxContainer/Sound/Master/MasterSlider, # Master slider
	$ScrollContainer/CenterContainer/VBoxContainer/Sound/SFX/SFXSlider, # SFX slider
	$ScrollContainer/CenterContainer/VBoxContainer/Sound/Music/MusicSlider, # Music slider
]
onready var _Fullscreen = $ScrollContainer/CenterContainer/VBoxContainer/Display/FullscreenCheckButton
onready var _Screenshake = $ScrollContainer/CenterContainer/VBoxContainer/Display/ScreenshakeCheckButton

# Called when the node enters the scene tree for the first time.
func _ready():
	for bus in range(3):
		_Sliders[bus].connect("value_changed", self, "_on_Sliders_value_changed", [bus])
		_Sliders[bus].value = Global.volumes[bus]
	
	_Fullscreen.connect("toggled", self, "_on_FullscreenCheckButton_toggled")
	_Screenshake.connect("toggled", self, "_on_ScreenshakeCheckButton_toggled")
	_Fullscreen.pressed = Global.fullscreen
	_Screenshake.pressed = Global.screenshake

func _process(delta: float) -> void:
	_Fullscreen.pressed = Global.fullscreen

func _on_Sliders_value_changed(value: float, bus: int):
	Global.volumes[bus] = value

func _on_FullscreenCheckButton_toggled(button_pressed):
	Global.fullscreen = button_pressed

func _on_ScreenshakeCheckButton_toggled(button_pressed):
	Global.screenshake = button_pressed
