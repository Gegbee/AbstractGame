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
					Global.player.custom_integrator = false
					if Global.player.cur_item != null:
						Global.player.cur_item.freeze = true
					await get_tree().process_frame
					Global.player.global_position = door.global_position
					Global.player.custom_integrator = true
					if Global.player.cur_item != null:
						Global.player.cur_item.global_position = Global.player.item_holder.global_position
						Global.player.cur_item.freeze = false
					# $Player.global_position = door.global_position <- USED WITH SCENE_SWITCHER

func enable_scene():
	$Camera.current = true
	spawn_at_door()
	
func disable_scene():
	$Camera.current = false
