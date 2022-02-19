extends Node2D

export var fireball: PackedScene = preload("res://Scenes/Gameplay/Fireball.tscn")
export var smoke_effect: PackedScene = preload("res://Scenes/Visuals/Effects/SmokeEffect.tscn")
export var shooting: = true
export(float, 0.1, 10.0) var delay = 1.0
export(float, 0.0, 10.0) var delay_offset = 0.0

var time: float

onready var _Visibility: = $VisibilityEnabler2D
onready var _Audio: = $Audio

# Called when the node enters the scene tree for the first time.
func _ready():
	time += delay_offset

func _process(delta: float) -> void:
	time += delta
	if time >= delay:
		time = 0.0
		# If the shooter is active, shoot
		if shooting and _Visibility.visible:
			shoot()

func shoot():
	_Audio.pitch_scale = randf()*0.5 + 0.2
	var new_smoke_effect = Global.create_at(smoke_effect, global_position, self)
	new_smoke_effect.rotation = rotation
	
	var new_fireball: = Global.create_at(fireball, global_position, self)
	new_fireball.rotation = rotation
