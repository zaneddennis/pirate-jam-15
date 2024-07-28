extends Resource
class_name Item


@export var name: String
@export var texture: Texture
@export var atlas_coords: Vector2 = Vector2(0, 0)
@export var hint: String
@export var is_placeable: bool = false
@export var place_id: int


func _to_string():
	return "<Item:%s>" % name


func GetInventoryText() -> String:
	return name + " - " + hint
