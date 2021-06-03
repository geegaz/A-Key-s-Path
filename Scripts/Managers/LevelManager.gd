extends Node

# Temporary data
var current_world: int = -1
var current_level: int = -1
var current_checkpoint: Node = null

# Saved data
var max_unlocked_world: int = 0
var max_unlocked_level: int = 0

var level_paths = []

func _ready():
	pass

# returns the next level from the current level and world
func get_next_level()->String:
	return ""

func unlock_level(world: int, level: int):
	pass

func to_dict()->Dictionary:
	var dict = {
		"max_unlocked_world": max_unlocked_world,
		"max_unlocked_level": max_unlocked_level
	}
	return dict
