extends StaticBody2D
class_name WorldObject


const INTERACT_DISTANCE = 96.0

enum INTERACT_TYPE {EXAMINE, READ, TAKE}

@export var display_name: String
@export var interaction: INTERACT_TYPE
@export var examination: String
@export var is_light_source: bool = false


func _ready():
	$Details.text = display_name
	$Interact.text = "Press [F] to " + INTERACT_TYPE.keys()[interaction].capitalize()
	if is_light_source:
		var coords = Link.world.GetCoords(position)
		Link.world.AddLight(coords)
		# todo: colors


func _on_mouse_entered():
	$Details.show()
	
	if Link.player:
		var player_pos = Link.player.position
		if position.distance_to(player_pos) <= INTERACT_DISTANCE:
			Link.player.interaction_target = self
			$Interact.show()  # todo: handle case where player leaves range while still moused over and also vice versa


func _on_mouse_exited():
	Link.player.interaction_target = null
	$Details.hide()
	$Interact.hide()
