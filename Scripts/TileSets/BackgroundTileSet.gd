extends TileSet
tool

func _is_tile_bound(drawn_id, neighbor_id):
	# ground = 0
	# metal = 1
	var bound = false
	match drawn_id:
		0:
			match neighbor_id:
				1:
					bound = true
	return bound
