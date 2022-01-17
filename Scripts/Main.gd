extends Node

enum {MAIN, LEVELS, OPTIONS, CREDITS}

var screen_pos = [Vector2.ZERO, Vector2.UP, Vector2.LEFT, Vector2.RIGHT]
var current_screen = MAIN

# Menu navigation
onready var StartButton = $MainMenu/VBoxContainer/Start
onready var OptionsButton = $MainMenu/VBoxContainer/HBoxContainer/Options
onready var CreditsButton = $MainMenu/VBoxContainer/HBoxContainer/Credits

onready var OptionsBackButton = $OptionsMenu/OptionsBack
onready var CreditsBackButton = $CreditsMenu/CreditsBack
onready var LevelsBackButton = $LevelsMenu/LevelsBack

onready var QuitButton = $MainMenu/Quit

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect every button
	StartButton.connect("pressed", self, "travel_to_screen", [LEVELS, LevelsBackButton])
	OptionsButton.connect("pressed", self, "travel_to_screen", [OPTIONS, OptionsBackButton])
	CreditsButton.connect("pressed", self, "travel_to_screen", [CREDITS, CreditsBackButton])
	
	OptionsBackButton.connect("pressed", self, "back")
	CreditsBackButton.connect("pressed", self, "back")
	LevelsBackButton.connect("pressed", self, "back")
	
	QuitButton.connect("pressed",self, "try_quit")
	
	StartButton.grab_focus()
	
	if OS.has_feature("HTML5"):
		QuitButton.hide()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if current_screen == MAIN:
			try_quit()
		else:
			back()

func back():
	travel_to_screen(MAIN)
	StartButton.grab_focus()

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

