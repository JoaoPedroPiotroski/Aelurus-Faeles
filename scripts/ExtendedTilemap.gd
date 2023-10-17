class_name ExtendedTilemap
extends TileMap

@export var replace_empty_with_navigation := true
@export var navigation_tile_source := 1
@export var navigation_tile_atlas_coords := Vector2i(1, 0)
@export var navigation_pretile_atlas_coords := Vector2i(2, 0)

func setup_navigation():
	for tile in get_used_cells(0):
		if get_cell_atlas_coords(0, tile) == navigation_pretile_atlas_coords:
			set_cell(0, Vector2i(tile),
			navigation_tile_source,
			navigation_tile_atlas_coords
			)
	
	force_update()

func _ready():
	if replace_empty_with_navigation:
		setup_navigation()
