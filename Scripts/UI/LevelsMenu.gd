extends Control

export(NodePath) var template_world_path
export(NodePath) var template_level_path
export(NodePath) var template_final_level_path

onready var _TemplateWorld: Node = get_node_or_null(template_world_path)
onready var _TemplateLevel: Node = get_node_or_null(template_level_path)
onready var _TemplateFinalLevel: Node = get_node_or_null(template_final_level_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func make_levels():
	pass
