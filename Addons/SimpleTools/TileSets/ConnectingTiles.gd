extends TileSet
tool

export(String, FILE, "*.json") var rules_file setget load_rules_file
var rules: Dictionary

#export(Array, String) var connecting_tiles_names = [] setget set_connecting_tiles_names
#export(Array, String) var sticky_tiles_names = [] setget set_excluding_tiles_names

var connecting = []
var sticky = []

func _is_tile_bound(drawn_id, neighbor_id):
	# Logic: a tile in the "connecting" group will connect to any other tile in the group
	return drawn_id in connecting and (neighbor_id in connecting or neighbor_id in sticky)

func find_tiles_by_names(names: Array)->Array:
	var new_array = []
	for name in names:
		var id = find_tile_by_name(name)
		if id != -1:
			new_array.append(id)
	return new_array

#func set_connecting_tiles_names(new_array: Array):
#	connecting = find_tiles_by_names(new_array)
#	connecting_tiles_names = new_array
#
#func set_excluding_tiles_names(new_array: Array):
#	sticky = find_tiles_by_names(new_array)
#	sticky_tiles_names = new_array

func load_rules_file(path: String):
	var file: File = File.new()
	file.open(path, File.READ)
	var json: JSONParseResult = JSON.parse(file.get_as_text())
	
	if json.error == OK:
		rules = json.result
		connecting = find_tiles_by_names(rules.get("connecting"))
		sticky = find_tiles_by_names(rules.get("sticky"))
		
		rules_file = path
	

