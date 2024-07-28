extends CharacterBody2D


const SPEED = 256
const PLACE_RANGE = 128

enum INPUT_MODE {NORMAL, EXAMINE, READ, CRAFT}


var inventory_ui: InventoryInterface
var crafting_ui: CraftingInterface


var input_mode: INPUT_MODE = INPUT_MODE.NORMAL
var interaction_target: WorldObject
var read_target: ReadInterface

@export var inventory = []  # Items
var selected_item_slot = 0
@export var ingredients = {}  # Item: quantity


func _ready():
	inventory_ui = Link.ui.get_node("Inventory")
	crafting_ui = Link.ui.get_node("Crafting")
	
	RefreshInventory()
	RefreshIngredients()


func _physics_process(delta):
	
	match input_mode:
		INPUT_MODE.NORMAL:
			var vector = Input.get_vector("walk_left", "walk_right", "walk_up", "walk_down")
			velocity = vector * SPEED
			move_and_slide()
			
			if Input.is_action_just_pressed("interact"):
				AttemptInteract()
			
			elif Input.is_action_just_pressed("use_item"):
				AttemptPlaceItem()
			
			elif Input.is_action_just_pressed("crafting"):
				OpenCrafting()
			
			elif Input.is_action_just_pressed("item_up"):
				selected_item_slot -= 1
				if selected_item_slot < 0:
					selected_item_slot = 7
				inventory_ui.SelectSlot(selected_item_slot)
			elif Input.is_action_just_pressed("item_down"):
				selected_item_slot += 1
				if selected_item_slot >= 8:
					selected_item_slot = 0
				inventory_ui.SelectSlot(selected_item_slot)
		
		INPUT_MODE.EXAMINE, INPUT_MODE.READ:
			if Input.is_action_just_pressed("interact"):
				read_target.TurnPage()
		
		INPUT_MODE.CRAFT:
			if Input.is_action_just_pressed("crafting"):
				crafting_ui.Close()
				input_mode = INPUT_MODE.NORMAL


func AttemptInteract():
	if interaction_target:
		print("Interact: ", interaction_target.interaction)
		
		match interaction_target.interaction:
			WorldObject.INTERACT_TYPE.EXAMINE:
				input_mode = INPUT_MODE.EXAMINE
				read_target = Link.ui.get_node("Examine") as ReadInterface
				read_target.Activate([interaction_target.examination] as Array[String])
			
			WorldObject.INTERACT_TYPE.READ:
				input_mode = INPUT_MODE.READ
				read_target = Link.ui.get_node("Read") as ReadInterface
				read_target.Activate(interaction_target.texts)
			
			WorldObject.INTERACT_TYPE.TAKE:
				var take_target = interaction_target as DispenserObject
				var item = take_target.item
				if item is Ingredient:
					if item in ingredients:
						ingredients[item] += 1
					else:
						ingredients[item] = 1
					Link.ui.get_node("Crafting").RefreshIngredients(ingredients)
				elif item is Item:
					AddItem(item)
				else:
					assert(false)
				
				if take_target.is_oneshot:
					Link.world.RemoveItem(take_target)  # assumes we are only removing Items
					var coords = Link.world.GetCoords(take_target.position)
					Link.world.RemoveLight(coords)


func AttemptPlaceItem():
	if selected_item_slot < len(inventory):
		var item: Item = inventory[selected_item_slot]
		if item.is_placeable:
			var mpos = get_global_mouse_position()
			var dist = position.distance_to(mpos)
			if dist <= PLACE_RANGE:
				var coords = Link.world.GetCoords(mpos)
				var item_already_there = Link.world.GetItem(coords)
				if not item_already_there:
					Link.world.PlaceItem(coords, item)
					inventory.remove_at(selected_item_slot)
					RefreshInventory()


func AddItem(item: Item):
	inventory.append(item)
	RefreshInventory()


func OpenCrafting():
	input_mode = INPUT_MODE.CRAFT
	crafting_ui.Open()


func RefreshInventory():
	inventory_ui.Refresh(inventory, selected_item_slot)

func RefreshIngredients():
	crafting_ui.RefreshIngredients(ingredients)
