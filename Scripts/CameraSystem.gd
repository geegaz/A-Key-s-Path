extends Node

export(NodePath) var Target_Path
export(float) var trans_time = 0.8

onready var _Target = get_node(Target_Path)
onready var _Camera = $Camera
onready var _Shaker = $Camera/Shaker
onready var _Tween = $Tween

onready var _Zones = get_tree().get_nodes_in_group("CameraZones")

var center = Vector2()
var free_x = true
var free_y = true
var zoom = 1.0

var target_reached = false
var reach_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	for zone in _Zones:
		zone.connect("zone_entered", self, "_on_CameraZone_zone_entered")

func _physics_process(delta):
	if !target_reached and _Target:
		reach_time += delta
		var target_pos = center
		if free_x:
			target_pos.x = _Target.position.x
		if free_y:
			target_pos.y = _Target.position.y
		
		_Camera.position = lerp(_Camera.position, target_pos, reach_time)
		target_reached = (reach_time >= trans_time)
		
	if target_reached and _Target:
		if free_x:
			_Camera.position.x = _Target.position.x
		if free_y:
			_Camera.position.y = _Target.position.y

func _on_CameraZone_zone_entered(center: Vector2, free_x: bool, free_y: bool, zoom: float):
	_Camera.zoom = Vector2(zoom, zoom)
	self.free_x = free_x
	self.free_y = free_y
	self.center = center
	
	target_reached = false
	reach_time = 0.0
