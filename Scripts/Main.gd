extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Credits.hide()

func _on_Back_pressed():
	$Credits.hide()

func _on_Credits_pressed():
	$Credits.show()

func _on_Start_pressed():
	Global.goto_scene("res://Scenes/World.tscn")

func _on_Quit_pressed():
	get_tree().quit()
