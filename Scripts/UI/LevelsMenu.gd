extends Control

export(NodePath) var template_level = "Templates/LevelButton"
export(NodePath) var template_final_level = "Templates/FinalLevelButton"

onready var _TemplateLevel: TextureButton = get_node_or_null(template_level)
onready var _TemplateFinalLevel: TextureButton = get_node_or_null(template_final_level)

onready var _LevelsContainer = $LevelsContainer
var level_buttons: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	make_levels()

func make_levels():
	for level in Global.level_paths.size(): # Oh damn, an int used as range !
		# Make every level
		var new_level: TextureButton
		if level == Global.level_paths.size()-1:
			new_level = _TemplateFinalLevel.duplicate()
		else:
			new_level = _TemplateLevel.duplicate()
		# If the level hasn't been unlocked yet
		if level >= Global.levels_unlocked:
			new_level.disabled = true
		
		# Connect button to its respective level
		new_level.connect("pressed", Global, "goto_level", [level])
		_LevelsContainer.add_child(new_level)
		new_level.show()
		
		level_buttons.append(new_level)

