extends Area2D

@export var convo : String = ""
# num of convos is how many different convos an NPC has, once convo_num >= num_of_convos the NPC
# will repeat the last convo
@export var num_of_convos : int = 1
@export var force_dialog : bool = false

var cur_convo_num : int = 0

@export var character_follow : NodePath

func _process(_delta):
	if has_node(character_follow):
		global_position = get_node(character_follow).global_position
