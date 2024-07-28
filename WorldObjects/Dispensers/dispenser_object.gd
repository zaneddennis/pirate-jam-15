extends WorldObject
class_name DispenserObject


@export var item: Item
@export var is_oneshot: bool = false


func _ready():
	super()
	$Interact.text = "Press [F] to take [%s]" % item.name
