class_name Shaker, "./Shaker.svg"
extends Node


const shake_decay: float = 0.8
const shake_power: float = 2.0

class ShakeProcess:
	var node: Node
	var property: String
	var property_default: Vector2
	
	var max_offset: = Vector2.ONE
	var offset: = Vector2.ZERO
	var shake: float = 0.0
	var speed: float = 1.0
	
	var noise: OpenSimplexNoise = OpenSimplexNoise.new()
	var noise_offset: float = 0.0
	
	func _init(node: Node, property: String) -> void:
		self.node = node
		self.property = property
		self.property_default = node.get(property)
		
		noise.seed = randi()
		noise.period = 4
		noise.octaves = 2
	
	func _process(delta: float)-> void:
		shake = max(shake - delta * shake_decay, 0)
		var amount = pow(shake, shake_power)
		offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed, noise_offset)
		offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*2, noise_offset)
		noise_offset += speed
		
		node.set(property, property_default + offset)
	
	func _reset()->void:
		shake = 0
		offset = Vector2.ZERO
		node.set(property, property_default)

var processes: Array = []

func _ready()-> void:
	pass

func _process(delta: float)-> void:
	for process in processes:
		if not process or not process.node or process.shake <= 0:
			processes.erase(process)
		else:
			process._process(delta)
	
func find_process(node: Node, property: String) -> int:
	for id in processes.size():
		if processes[id].node == node and processes[id].property == property:
			return id
	return -1

func has_process(node: Node, property: String) -> bool:
	return not find_process(node, property) < 0

func remove_process(node: Node, property: String) -> void:
	processes.remove(find_process(node, property))

func add_shake(node: Node, property: String, offset: Vector2, value: float, speed: float):
	var id = find_process(node, property)
	if id < 0:
		processes.append(ShakeProcess.new(node, property))
	# If the process didn't exist before, 
	# a negative index will focus the last one
	processes[id].max_offset = offset
	processes[id].speed = speed
	processes[id].shake = min(processes[id].shake + value, 1.0)

func set_active(value: bool) -> void:
	for process in processes:
		if not process or not process.node:
			processes.remove(process)
		else:
			process._reset()
	set_process(value)
