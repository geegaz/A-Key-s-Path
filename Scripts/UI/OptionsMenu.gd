extends Control

export(NodePath) var pause_menu_path
onready var _PauseMenu = get_node_or_null(pause_menu_path)

export(Array, NodePath) var slider_paths = [
	"ScrollContainer/CenterContainer/VBoxContainer/Sound/Master/MasterSlider", # Master slider
	"ScrollContainer/CenterContainer/VBoxContainer/Sound/SFX/SFXSlider", # SFX slider
	"ScrollContainer/CenterContainer/VBoxContainer/Sound/Music/MusicSlider", # Music slider
]
export(Array, NodePath) var slider_number_paths = [
	"ScrollContainer/CenterContainer/VBoxContainer/Sound/Master/Number", # Master slider
	"ScrollContainer/CenterContainer/VBoxContainer/Sound/SFX/Number", # SFX slider
	"ScrollContainer/CenterContainer/VBoxContainer/Sound/Music/Number", # Music slider
]
export(NodePath) var fullscreen_path = "ScrollContainer/CenterContainer/VBoxContainer/Display/FullscreenCheckButton"
export(NodePath) var screenshake_path = "ScrollContainer/CenterContainer/VBoxContainer/Display/ScreenshakeCheckButton"
export(NodePath) var back_path = "ScrollContainer/CenterContainer/VBoxContainer/CenterContainer/Back"

# 0, 1, 2 -> Bus == node_path index
enum {MASTER, SFX, MUSIC}

# Called when the node enters the scene tree for the first time.
func _ready():
	for bus in range(3):
		get_node(slider_paths[bus]).value = OptionManager.volumes[bus]
		set_slider_number(bus, OptionManager.volumes[bus])
	get_node(fullscreen_path).pressed = OptionManager.fullscreen
	get_node(screenshake_path).pressed = OptionManager.screenshake
	
	if _PauseMenu:
		get_node(back_path).show()
		self.hide()

func set_slider_number(slider_id: int, value: float):
	get_node(slider_number_paths[slider_id]).text = str(value*100)

func back():
	if _PauseMenu:
		_PauseMenu.show()
		self.hide()

func _on_MasterSlider_value_changed(value):
	set_slider_number(MASTER, value)
	OptionManager.volumes[MASTER] = value
	
func _on_SFXSlider_value_changed(value):
	set_slider_number(SFX, value)
	OptionManager.volumes[SFX] = value

func _on_MusicSlider_value_changed(value):
	set_slider_number(MUSIC, value)
	OptionManager.volumes[MUSIC] = value

func _on_FullscreenCheckButton_toggled(button_pressed):
	OptionManager.fullscreen = button_pressed

func _on_ScreenshakeCheckButton_toggled(button_pressed):
	OptionManager.screenshake = button_pressed

func _on_Back_pressed():
	back()
