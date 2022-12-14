extends Node2D
class_name Level2D

# Called when the node enters the scene tree for the first time.
#func _ready():
#	spawn_at_door()
	
func spawn_at_door():
	if $Doors != null:
		for door in $Doors.get_children():
			if door.door_index == Global.last_scene_door_index:
				if is_instance_valid(Global.player):
					if Global.player.cur_item != null:
						Global.player.cur_item.reset_position = door.global_position + door.relative_spawn + Global.player.item_holder.position
						Global.player.cur_item.reset_state = true
					Global.player.reset_position = door.global_position + door.relative_spawn
					Global.player.reset_state = true
					# $Player.global_position = door.global_position <- USED WITH SCENE_SWITCHER

func enable_scene():
	$Camera.current = true
	spawn_at_door()
	
func disable_scene():
	$Camera.current = false
