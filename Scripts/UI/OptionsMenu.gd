extends Control

export(NodePath) var pause_menu_path
onready var _PauseMenu = get_node_or_null(pause_menu_path)

export(Array, NodePath) var slider_paths = [
	"", # Master slider
	"ScrollContainer/CenterContainer/VBoxContainer/Sound/SFX/SFXSlider", # SFX slider
	"ScrollContainer/CenterContainer/VBoxContainer/Sound/Music/MusicSlider", # Music slider
]
export(Array, NodePath) var slider_number_paths = [
	"", # Master slider
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
	get_node(slider_paths[SFX]).value = get_volume(SFX)
	get_node(slider_paths[MUSIC]).value = get_volume(MUSIC)
	set_slider_number(SFX, get_volume(SFX))
	set_slider_number(MUSIC, get_volume(MUSIC))
	get_node(fullscreen_path).pressed = OS.window_fullscreen
	get_node(screenshake_path).pressed = Global.screenshake
	if _PauseMenu:
		get_node(back_path).show()
		self.hide()

func _input(event):
	if event.is_action_pressed("fullscreen"):
		set_fullscreen(!OS.window_fullscreen)

func get_volume(bus: int)->float:
	return db2linear(AudioServer.get_bus_volume_db(bus))

func set_volume(bus: int, volume_scale: float):
	set_slider_number(bus, volume_scale)
	var volume = linear2db(volume_scale)
	match bus:
		SFX:
			AudioServer.set_bus_volume_db(SFX, volume)
		MUSIC:
			AudioServer.set_bus_volume_db(MUSIC, volume)

func set_slider_number(slider_id: int, value: float):
	get_node(slider_number_paths[slider_id]).text = str(value*100)

func set_fullscreen(state: bool):
	OS.window_fullscreen = state
	get_node(fullscreen_path).pressed = state

func back():
	if _PauseMenu:
		_PauseMenu.show()
		self.hide()


func _on_SFXSlider_value_changed(value):
	set_volume(SFX, value)

func _on_MusicSlider_value_changed(value):
	set_volume(MUSIC, value)

func _on_FullscreenCheckButton_toggled(button_pressed):
	set_fullscreen(button_pressed)

func _on_ScreenshakeCheckButton_toggled(button_pressed):
	Global.screenshake = button_pressed

func _on_Back_pressed():
	back()

