extends Node

enum {MAIN, LEVELS, OPTIONS, CREDITS}

var screen_pos = [Vector2.ZERO, Vector2.UP, Vector2.LEFT, Vector2.RIGHT]
var current_screen = MAIN

# Menu navigation
onready var _LevelsMenu: Control = $LevelsMenu

onready var _StartButton = $MainMenu/VBoxContainer/Start
onready var _OptionsButton = $MainMenu/VBoxContainer/HBoxContainer/Options
onready var _CreditsButton = $MainMenu/VBoxContainer/HBoxContainer/Credits

onready var _OptionsBackButton = $OptionsMenu/OptionsBack
onready var _CreditsBackButton = $CreditsMenu/CreditsBack
onready var _LevelsBackButton = $LevelsMenu/LevelsBack

onready var _QuitButton = $MainMenu/Quit

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect every button
	_StartButton.connect("pressed", self, "travel_to_screen", [LEVELS, _LevelsMenu.level_buttons.front()])
	_OptionsButton.connect("pressed", self, "travel_to_screen", [OPTIONS, _OptionsBackButton])
	_CreditsButton.connect("pressed", self, "travel_to_screen", [CREDITS, _CreditsBackButton])
	
	_OptionsBackButton.connect("pressed", self, "back")
	_CreditsBackButton.connect("pressed", self, "back")
	_LevelsBackButton.connect("pressed", self, "back")
	
	_QuitButton.connect("pressed",self, "try_quit")
	
	_StartButton.grab_focus()
	
	if OS.has_feature("HTML5"):
		_QuitButton.hide()
	
	Global._Music.change_music("Background_ambiance", 1.0)

func _input(event):
	if event.is_action_pressed("fullscreen"):
		pass
	
	if event.is_action_pressed("ui_cancel"):
		if current_screen == MAIN:
			try_quit()
		else:
			back()

func back():
	travel_to_screen(MAIN)
	_StartButton.grab_focus()

func travel_to_screen(new_screen: int, focus_button: Control = null):
	if new_screen > 3:
		return
	
	current_screen = new_screen
	var tween = $Tween
	tween.remove($Camera2D)
	tween.interpolate_property(
		$Camera2D, "position",
		$Camera2D.position, 
		screen_pos[current_screen]*Vector2(320, 180), 
		0.5, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	if !tween.is_active():
		tween.start()
	
	if focus_button:
		focus_button.grab_focus()

func try_quit():
	get_tree().quit()

