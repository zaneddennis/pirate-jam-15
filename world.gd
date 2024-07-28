extends Node2D
class_name World

@onready var tilemap: TileMap = $TileMap

const ITEMS = [null, null, null, null, "candle"]


func _ready():
	pass


func GetCoords(pos: Vector2) -> Vector2i:
	return tilemap.local_to_map(pos)

func GetItem(coords: Vector2i):
	var item_tile = tilemap.get_cell_alternative_tile(3, coords)
	if item_tile != -1:
		return ITEMS[item_tile]
	else:
		return null


func PlaceItem(coords: Vector2i, item: Item):
	print("Placing ", item, " at ", coords)
	tilemap.set_cell(3, coords, 1, Vector2i(0, 0), item.place_id)

func RemoveItem(target: WorldObject):
	var coords = GetCoords(target.position)
	tilemap.erase_cell(3, coords)


func AddLight(coords: Vector2i):
	var coords_array = []
	for x in range(-2, 3):
		for y in range(-2, 3):
			coords_array.append(coords + Vector2i(x, y))
	
	tilemap.set_cells_terrain_connect(4, coords_array, 0, 0, false)

func RemoveLight(coords: Vector2i):
	var coords_array = []
	for x in range(-2, 3):
		for y in range(-2, 3):
			coords_array.append(coords + Vector2i(x, y))
	for c in coords_array:
		tilemap.erase_cell(4, c)
