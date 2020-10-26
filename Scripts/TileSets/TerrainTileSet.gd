extends TileSet
tool

func _is_tile_bound(drawn_id, neighbor_id):
	# ground = 0
	# rock = 1
	# metal = 3
	# blue tiles = 6
	# sand = 7
	# grass_ground = 8
	# grass_rock = 9
	# platform = 10
	var bound = false
	match drawn_id:
		0,1,6,8,9:
			match neighbor_id:
				0,1,3,6,8,9:
					bound = true
		7:
			match neighbor_id:
				0,1,3,6,8,9:
					bound = true
		10:
			match neighbor_id:
				-1:
					bound = true
	return bound
