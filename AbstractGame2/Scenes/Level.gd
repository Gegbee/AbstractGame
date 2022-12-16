extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if $Doors != null:
		for door in $Doors.get_children():
			if door.door_index == Global.last_scene_door_index:
				$Player.global_position = door.global_position
