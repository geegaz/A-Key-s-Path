extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$MainMenu/MainMenuContainer/CenterContainer/VBoxContainer/Start.grab_focus()

func _on_Back_pressed():
	$AnimationPlayer.play("credits_to_menu")

func _on_Credits_pressed():
	$AnimationPlayer.play("goto_credits")

func _on_Start_pressed():
	Global.goto_scene("res://Scenes/World.tscn")

func _on_Quit_pressed():
	get_tree().quit()
