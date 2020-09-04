extends TileSet
tool

func _is_tile_bound(drawn_id, neighbor_id):
	# ground = 0
	# rock = 1
	# transition = 4
	# metal = 3
	var bound = false
	match drawn_id:
		0:
			match neighbor_id:
				1:
					bound = true
				4:
					bound = true
		3,4:
			match neighbor_id:
				3,4:
					bound = true
	return bound
