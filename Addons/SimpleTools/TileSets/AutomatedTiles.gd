extends "./ConnectingTiles.gd"
tool

export(bool) var create_shapes: bool = true setget set_create_shape

var automated = []

enum {SUCCESS, ERROR}

func set_create_shape(_state: bool):
	if !Engine.editor_hint:
		# Skip function if not in the editor
		return
	
	automated = find_tiles_by_names(rules.get("automated"))
	
	var result: int = create_collisions()
	match result:
		SUCCESS:
			create_shapes = true
			print("Shapes created successfuly")
		ERROR:
			create_shapes = false
			print("Error while creating shapes")

func create_collisions()->int:
	for tile in automated:
		var new_shape = ConvexPolygonShape2D.new()
		tile_set_shapes(tile, [])
		var tile_size: Vector2
		
		match tile_get_tile_mode(tile):
			AUTO_TILE:
				tile_size = autotile_get_size(tile)
				new_shape.set_points([Vector2.ZERO, Vector2(tile_size.x, 0), tile_size, Vector2(0, tile_size.y)])
				
				# Find the number of cells in the autotile
				var autotile_size = tile_get_region(tile).size / tile_size
				for x in autotile_size.x:
					for y in autotile_size.y:
						# Make sure the current cell has a bit set
						if autotile_get_bitmask(tile, Vector2(x, y)) > 0:
							tile_add_shape(tile, new_shape, Transform2D(), false, Vector2(x, y))
			SINGLE_TILE:
				# Find the size of the tile
				tile_size = tile_get_region(tile).size
				new_shape.set_points([Vector2.ZERO, Vector2(tile_size.x, 0), tile_size, Vector2(0, tile_size.y)])
				tile_add_shape(tile, new_shape, Transform2D(), false, Vector2.ZERO)
			
			ATLAS_TILE:
				tile_size = autotile_get_size(tile)
				new_shape.set_points([Vector2.ZERO, Vector2(tile_size.x, 0), tile_size, Vector2(0, tile_size.y)])
				
				# Find the number of cells in the atlas
				var atlas_size = tile_get_region(tile).size / tile_size
				for x in atlas_size.x:
					for y in atlas_size.y:
						tile_add_shape(tile, new_shape, Transform2D(), false, Vector2(x, y))
			_:
				print("Unknow error - invalid type of tile")
				return ERROR
	
	return SUCCESS
