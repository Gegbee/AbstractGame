extends Level2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Doors/RoomTrigger2.locked = false
	



func _on_room_trigger_2_body_entered(body):
	if body.is_in_group('Key'):
		$Doors/RoomTrigger2.locked = false
