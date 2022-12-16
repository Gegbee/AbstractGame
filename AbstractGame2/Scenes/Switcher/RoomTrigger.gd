extends Area2D

@export var room_name : String = "Test"
@export var door_index : int = 0
@export var relative_spawn : Vector2 = Vector2()
#
#func _on_RoomTrigger_body_entered(body):
#	pass
#	if body.is_in_group("Player"):
#		Global.last_scene_door_index = door_index
#		get_tree().get_current_scene().switch_scene(room_index) # use scene_controller
#

