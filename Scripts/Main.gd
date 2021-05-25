extends Node

# Menu navigation
onready var StartButton = $MainMenu/VBoxContainer/Start
onready var QuitButton = $MainMenu/Quit
onready var OptionsButton = $MainMenu/VBoxContainer/HBoxContainer/Options
onready var CreditsButton = $MainMenu/VBoxContainer/HBoxContainer/Credits
onready var OptionsBackButton = $OptionsMenu/OptionsBack
onready var CreditsBackButton = $CreditsMenu/CreditsBack
onready var LevelsBackButton = $LevelsMenu/LevelsBack

enum {MAIN, LEVELS, OPTIONS, CREDITS}
var screen_pos = [Vector2.ZERO, Vector2.UP, Vector2.LEFT, Vector2.RIGHT]
var current_screen = MAIN

# Called when the node enters the scene tree for the first time.
func _ready():
	StartButton.grab_focus()
	
	if Global.show_levels:
		$Camera2D.position = Vector2(160,-96)
		LevelsBackButton.grab_focus()
		Global.show_levels = false
	
	if OS.has_feature("HTML5"):
		QuitButton.hide()

func _input(event):
	if event.is_action_pressed("quit"):
		if current_screen == MAIN:
			get_tree().quit()
		else:
			back()

func back():
	travel_to_screen(MAIN)
	StartButton.grab_focus()

func travel_to_screen(new_screen: int):
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


func _on_Quit_pressed():
	get_tree().quit()

func _on_Start_pressed():
	travel_to_screen(LEVELS)
	LevelsBackButton.grab_focus()

func _on_Options_pressed():
	travel_to_screen(OPTIONS)
	OptionsBackButton.grab_focus()

func _on_Credits_pressed():
	travel_to_screen(CREDITS)
	CreditsBackButton.grab_focus()

func _on_OptionsBack_pressed():
	back()
	
func _on_CreditsBack_pressed():
	back()

func _on_LevelsBack_pressed():
	back()

