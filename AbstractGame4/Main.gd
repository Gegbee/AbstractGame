extends Node2D

class_name Dialog2D

onready var speakers = {
	"Dad" : $EntDad,
	"Jules" : $EntPlayer
}

var input_to_continue : bool = false

func _ready():
	Global.dialog = self
	#start_convo("dad-jules-greeting")
	
func start_convo(convo_name : String):
	if Global.convos[convo_name] == null:
		return
		
	var new_convo = Global.convos[convo_name]
	
	if new_convo["interrupt"]:
		for participant in new_convo["participants"]:
			speakers[new_convo["convo"][0][0]].leave_convo()
		# end current convos in participants because convo is interrupt mandatory
	else:
		var can_continue = true
		for participant in new_convo["participants"]:
			if speakers[new_convo["convo"][0][0]].in_convo():
				can_continue = false
		if !can_continue:
			print("Participants occupied")
			return
		# continue here
		if new_convo["lock_player"]:
			Global.player.set_disabled(true)
		var start_convo_pos = 0
		var start_speaker = speakers[new_convo["convo"][start_convo_pos][0]]
		start_speaker.join_convo(convo_name, start_convo_pos)
		
		
func end_convo(convo_name : String):
	# This is when a certain convo has finished and needs terminating in the participants
	# Will be triggered by the speaker with the last line in the convo that was started
	if Global.convos[convo_name] == null:
		return
		
	var new_convo = Global.convos[convo_name]
	if new_convo["lock_player"]:
		Global.player.set_disabled(false)
	for participant in new_convo["participants"]:
		speakers[participant].leave_convo()
