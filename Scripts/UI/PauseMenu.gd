extends Control

onready var _OptionsMenu: Control = $OptionsMenu
onready var _Options: Button = $Pause/CenterContainer/VBoxContainer/Options
onready var _OptionsBack: Button = $OptionsMenu/OptionsBack

onready var _Pause: Control = $Pause
onready var _Continue: Button = $Pause/CenterContainer/VBoxContainer/Continue

enum {
	PAUSE,
	OPTIONS
}

func _ready():
	pause(get_tree().paused)
	goto_menu(-1)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if _OptionsMenu and _OptionsMenu.visible:
			goto_menu(PAUSE)
		else:
			pause(!get_tree().paused)

func pause(state: bool):
	if state:
		goto_menu(PAUSE)
	else:
		goto_menu(-1)
	get_tree().paused = state

func goto_menu(menu: int):
	match menu:
		PAUSE:
			_OptionsMenu.hide()
			_Pause.show()
			
			_Continue.grab_focus()
		OPTIONS:
			_OptionsMenu.show()
			_Pause.hide() 
			
			_OptionsBack.grab_focus()
		_:
			_OptionsMenu.hide()
			_Pause.hide() 

func _on_Continue_pressed():
	pause(false)

func _on_BackToMenu_pressed():
	pause(false)
	Global.goto_scene(Global.default_path)

func _on_Options_pressed():
	if _OptionsMenu:
		goto_menu(OPTIONS)

func _on_OptionsBack_pressed():
	if _OptionsMenu and _OptionsMenu.visible:
		goto_menu(PAUSE)
