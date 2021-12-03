extends Control
tool

export(Vector2) var min_size = Vector2(320, 180) setget set_min_size

# Called when the node enters the scene tree for the first time.
func _ready():
	set_layers_size()


func set_min_size(new_size: Vector2):
	min_size = new_size
	set_layers_size()

func set_layers_size():
	var _BackgroundLayer = get_first_background()
	if !_BackgroundLayer:
		return
	
	var layers = []
	for child in _BackgroundLayer.get_children():
		if child is ParallaxLayer:
			layers.append(child)
	if layers.size() <= 0:
		return
	
	for layer in layers:
		for child in layer.get_children():
			if child.is_class("Control"):
				child.rect_size = min_size + (self.rect_size-min_size) * layer.motion_scale
				child.rect_position = self.rect_position * layer.motion_scale
	
func get_first_background()->Node:
	for child in get_children():
		if child is ParallaxBackground:
			return child
	# If no background has been found, return null
	return null

func _on_Background_item_rect_changed():
	self.rect_size.x = max(self.rect_size.x, min_size.x)
	self.rect_size.y = max(self.rect_size.y, min_size.y)
	set_layers_size()

func _get_configuration_warning():
	var _BackgroundLayer = get_first_background()
	if !_BackgroundLayer:
		return "Background needs a ParallaxBackground as a child to work"
	else:
		return ""
		
