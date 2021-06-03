extends TileSet
tool

export(Array, String) var connecting_tiles_names = [] setget set_connecting_tiles_names
export(Array, String) var sticking_tiles_names = [] setget set_excluding_tiles_names

var connecting = []
var sticking = []

func _is_tile_bound(drawn_id, neighbor_id):
	# Logic: a tile in the "connecting" group will connect to any other tile in the group
	if drawn_id in connecting and (neighbor_id in connecting or neighbor_id in sticking):
		return true

func find_tiles_by_names(names: Array)->Array:
	var new_array = []
	for name in names:
		var id = find_tile_by_name(name)
		if id != -1:
			new_array.append(id)
	return new_array

func set_connecting_tiles_names(new_array: Array):
	connecting = find_tiles_by_names(new_array)
	connecting_tiles_names = new_array

func set_excluding_tiles_names(new_array: Array):
	sticking = find_tiles_by_names(new_array)
	sticking_tiles_names = new_array

