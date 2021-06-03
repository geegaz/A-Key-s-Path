extends Node

signal start_shake
signal stop_shake

var shaking: bool

var shake_intensity: float
var shake_scale: float
var shake_time: float
var elapsed_time: float

var offset = Vector2.ZERO

var target_node: Node
var target_property: String
var target_property_start: Vector2

func _ready():
	shaking = false

func _process(delta):
	if shaking:
		_shake_process(delta)

func _shake_process(delta):
	# When shaking is finished, return the property to its original state
	if elapsed_time > shake_time or !Global.screenshake:
		stop_shake()
	# When shaking, calculate the offset
	else:
		offset =  Vector2(
			0,
			sin(PI*elapsed_time/(2*shake_time)+PI/2)*sin(PI*elapsed_time*shake_intensity)
			) * shake_scale
		elapsed_time += delta
	# Applies the calculated offset to the property
	target_node.set(target_property, target_property_start+offset)

# Launches the shaking
# If the property name doesn't exist in the node,
# will raise an error "trying to assign NiL to Vector2"
func shake(node: Node, property: String, scale: float, time: float, intensity: float = 80.0):
	if node != target_node or property != target_property:
		stop_shake()
		target_node = node
		target_property = property
		target_property_start = target_node.get(target_property)
	shake_intensity = intensity
	shake_scale = scale
	shake_time = time
	elapsed_time = 0.0
	if !shaking:
		shaking = true
		emit_signal("start_shake")

func stop_shake():
	shaking = false
	offset = Vector2.ZERO
	emit_signal("stop_shake")
