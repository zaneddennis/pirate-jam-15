extends Control
class_name InventoryInterface


var ItemWidget = preload("res://UI/Widgets/item_widget.tscn")


var item_list: Array


func Refresh(items: Array, select_slot: int):
	for n in $Slots.get_children():
		n.queue_free()
	
	item_list = items
	for item: Item in items:
		var iw = ItemWidget.instantiate()
		iw.texture.region.position = item.atlas_coords * 64
		$Slots.add_child(iw)
	
	SelectSlot(select_slot)


func SelectSlot(s: int):
	$Selection.position.x = s * 64
	if s < len(item_list):
		$Label.text = item_list[s].GetInventoryText() #item_list[s].name
	else:
		$Label.text = ""
