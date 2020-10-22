extends TileSet
tool

func _is_tile_bound(drawn_id, neighbor_id):
	# ground = 0
	# rock = 1
	# transition = 2
	# metal = 3
	# leaves = 5
	# blue tiles = 6
	# sand = 7
	var bound = false
	match drawn_id:
		0,1,6,7:
			match neighbor_id:
				0,1,2,6:
					bound = true
		3,2:
			match neighbor_id:
				3,2:
					bound = true
		5:
			match neighbor_id:
				0,1,2,3,6,7:
					bound = true
		7:
			match neighbor_id:
				0,1,2,3,6:
					bound = true
	return bound
