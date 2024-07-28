extends ReferenceRect
class_name IngredientSlot


signal highlighted(slot: IngredientSlot)


var ingredient: Ingredient
var quantity: int


func Clear():
	ingredient = null
	quantity = 0
	$TextureRect.hide()
	$Label.hide()


func Refresh():
	if ingredient:
		$TextureRect.texture.region.position = ingredient.atlas_coords * 64
		$Label.text = str(quantity)
	
		$TextureRect.show()
		$Label.show()


func SetItem(i: Ingredient, q: int):
	ingredient = i
	quantity = q
	Refresh()


func AddItem(ing: Ingredient):
	if ingredient:
		assert(ingredient.name == ing.name)
		quantity += 1
		Refresh()
	else:
		SetItem(ing, 1)


func DecrementItem():
	quantity -= 1
	if quantity <= 0:
		Clear()
	else:
		Refresh()


func _get_drag_data(at_position):
	var preview = TextureRect.new()
	preview.texture = ingredient.texture
	set_drag_preview(preview)
	
	var ing = ingredient.duplicate(true)
	DecrementItem()
	return {"ingredient": ing, "slot_from": self}


func _can_drop_data(at_position, data):
	return (not ingredient or ingredient.name == data["ingredient"].name) and Rect2i(Vector2i(0, 0), get_rect().size).has_point(at_position)


func _drop_data(at_position, data):
	AddItem(data["ingredient"])


func _on_mouse_entered():
	$Highlight.show()
	highlighted.emit(self)


func _on_mouse_exited():
	$Highlight.hide()
