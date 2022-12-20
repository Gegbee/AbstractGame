extends Node

var scenes_in_game : Dictionary = {
	"Test" : preload("res://Test.tscn"),
	"Bedroom" : preload("res://Scenes/Bedroom.tscn"),
	"LivingRoom" : preload("res://Scenes/LivingRoom.tscn"),
	"DiningRoom" : preload("res://Scenes/DiningRoom.tscn"),
}

var cur_scene_name : String = ""
var cur_scene = null

var scene_transition_time : float = 3.0
enum {
	IN_SCENE,
	TRANS_OUT,
	TRANS_MID,
	TRANS_IN
}
var state = IN_SCENE

func _ready():
	switch_scene("Bedroom")
		
func switch_scene(new_scene_name):
	if state == IN_SCENE:
		if scenes_in_game.keys().has(new_scene_name):
			if scenes_in_game[new_scene_name] != null:
				state = TRANS_IN
				cur_scene_name = new_scene_name
				change_state()
			else:
				print("Cur scene does not have a complementary scene")
		else:
			print("Cur scene name does not exist")

func change_state():
	if state == TRANS_IN:
		state = TRANS_MID
		change_state()
	elif state == TRANS_MID:
		state = TRANS_OUT
		if cur_scene != null:
			cur_scene.free()
		cur_scene = scenes_in_game[cur_scene_name].instantiate()
		add_child(cur_scene)
		change_state()
	elif state == TRANS_OUT:
		state = IN_SCENE
	elif state == IN_SCENE:
		pass
