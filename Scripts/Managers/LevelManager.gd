extends Node

# Used inside level
var current_world: int = -1
var current_level: int = -1
var current_checkpoint: Node = null

# Used in menu
var max_unlocked_world: int = 0
var max_unlocked_level: int = 0

# World data
var world_names = []
var level_paths = []
var menu_path: String = ""

func _ready():
	var data_path = "res://Data/Worlds.json"
	
	# TODO: read world data
	

func is_level_valid(world: int, level: int)->bool:
	if world >= max_unlocked_world and world < level_paths.size():
		if level >= max_unlocked_level and level < level_paths[world].size():
			return true
		else:
			print("Invalid level: %s %s"%[world,level])
	else:
		print("Invalid world: %s %s"%[world,level])
	return false


func get_next_level_path()->String:
	# Only works if the current_world and current_level have been set
	if current_world >= 0 and current_level >= 0:
		# If the next level is out of the range of available levels,
		# reset it and go to the next world
		if current_level+1 >= level_paths[current_world].size():
			return get_level_path(current_world+1, 0)
		else:
			return get_level_path(current_world, current_level+1)
	else:
		print("current_world and current_level have not been set")
	return ""

# Behavior for invalid values: 
# returns an empty string if the world or level is outside of existing values
func get_level_path(world: int, level: int)->String:
	if is_level_valid(world, level):
		return level_paths[world][level]
	return ""

# Behavior for invalid values: 
# doesn't unlock any new levels if the world or level is outside of existing values
func unlock_level(world: int, level: int):
	if is_level_valid(world, level):
		max_unlocked_world = world
		max_unlocked_level = level

func unlock_next_level():
	# Only works if the current_world and current_level have been set
	if current_world >= 0 and current_level >= 0:
		# If the next level is out of the range of available levels,
		# reset it and go to the next world
		if current_level+1 >= level_paths[current_world].size():
			unlock_level(current_world+1, 0)
		else:
			unlock_level(current_world, current_level+1)

func unlock_all_levels():
	var last_world = level_paths.size() - 1
	var last_level = level_paths[last_world].size() - 1
	
	# Invalid world or level will be handled by unlock_level
	unlock_level(last_world, last_level)

func to_dict()->Dictionary:
	var dict = {
		"max_unlocked_world": max_unlocked_world,
		"max_unlocked_level": max_unlocked_level
	}
	return dict
