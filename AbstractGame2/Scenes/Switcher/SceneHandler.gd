extends Node

@onready var scenes_in_game : Dictionary = {
	"Bedroom" : $Bedroom,
	"LivingRoom" : $LivingRoom,
	"DiningRoom" : $DiningRoom,
	"OutsideHouse" : $OutsideHouse,
	"OutsideCamps" : $OutsideCamps
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
	for scene_name in scenes_in_game:
		scenes_in_game[scene_name].disable_scene()
#		scene.hide()
#		scene.set_process(false)
	switch_scene("DiningRoom")
		
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
#		cur_scene.hide()
#		cur_scene.set_process(false)
		if cur_scene != null:
			cur_scene.disable_scene()
		cur_scene = scenes_in_game[cur_scene_name]
#		cur_scene.hide()
#		cur_scene.set_process(true)
		cur_scene.enable_scene()
		change_state()
	elif state == TRANS_OUT:
		state = IN_SCENE
	elif state == IN_SCENE:
		pass
