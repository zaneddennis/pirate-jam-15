extends Control
class_name CraftingInterface


const RECIPE_LIST = {  # alphabetical because Godot doesn't have Sets for some reason
	["Wax", "Wick"]: "candle",
	["Blue Flower", "Wax", "Wick"]: "blue_candle"
}


func _ready():
	for slot in $Ingredients/Slots.get_children():
		slot.highlighted.connect(_on_ingredient_slot_highlighted)


func Open():
	$Ingredients.position.x = 0
	$Crafting.show()
	$Recipes.show()


func Close():
	$Ingredients.position.x = -1 * $Ingredients.size.x
	$Crafting.hide()
	$Recipes.hide()


func RefreshIngredients(ingredients: Dictionary):
	var i = 0
	for iw: IngredientSlot in $Ingredients/Slots.get_children():
		if i < len(ingredients):
			var ing = ingredients.keys()[i]
			var q = ingredients[ing]
			iw.SetItem(ing, q)
			i += 1
		else:
			iw.Clear()


func _on_ingredient_slot_highlighted(slot: IngredientSlot):
	if slot.ingredient:
		$Ingredients/Label.text = slot.ingredient.name
	else:
		$Ingredients/Label.text = ""


func _on_create_pressed():
	var ingredients = []
	for slot: IngredientSlot in $Crafting/Slots.get_children():
		if slot.ingredient:
			ingredients.append(slot.ingredient.name)
	ingredients.sort()
	
	if ingredients in RECIPE_LIST:
		var product = load("res://Items/%s.tres" % RECIPE_LIST[ingredients])
		Link.player.AddItem(product)
		
		for slot: IngredientSlot in $Crafting/Slots.get_children():
			slot.Clear()
