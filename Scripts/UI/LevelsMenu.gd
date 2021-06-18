extends Control

export(NodePath) var template_world_path
export(NodePath) var template_level_path
export(NodePath) var template_final_level_path

onready var _TemplateWorld: Node = get_node_or_null(template_world_path)
onready var _TemplateLevel: Node = get_node_or_null(template_level_path)
onready var _TemplateFinalLevel: Node = get_node_or_null(template_final_level_path)

# Called when the node enters the scene tree for the first time.
func _ready():
	make_levels()

func make_levels():
	for world_nb in Global.worlds_data.size():
		var world = Global.worlds_data[world_nb]
		var new_world: Control = _TemplateWorld.duplicate()
		new_world.get_node("WorldLabel").text = world["name"]
		# Make every level
		for level_nb in world["levels"].size():
			var new_level: TextureButton
			# Select if the level is
			if level_nb == world["levels"].size()-1:
				new_level = _TemplateFinalLevel.duplicate()
			else:
				new_level = _TemplateLevel.duplicate()
			# If the level hasn't been unlocked yet
			if level_nb >= world["unlocked_levels"]:
				new_level.disabled = true
			# Connect button to its respective level
			new_level.connect("pressed", Global, "goto_level", [world_nb, level_nb])
			
			# Add new_level to the world
			new_world.get_node("WorldLevels").add_child(new_level)
			new_level.show()
		$WorldsContainer.add_child(new_world)
		new_world.show()

