extends Dialog2D

var talked_to_granny : bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if is_instance_valid(Global.player):
		Global.player.set_asleep(true)
	super()


func _on_dad_npc_convo_finished(speaker, convo_name):
	if convo_name == 'dad-1':
		speaker.cur_pot_convo = 'dad-2'


func _on_pol_gra_area_body_entered(body):
	if body.is_in_group('player'):
		start_convo('officer-granny')



func _on_granny_npc_convo_finished(speaker, convo_name):
	if convo_name == 'officer-granny':
		speaker.cur_pot_convo = 'granny-jules-1'
		talked_to_granny = true
	elif convo_name == 'granny-jules-1':
		speaker.cur_pot_convo = 'granny-jules-2'
		$SisterNPC.cur_pot_convo = 'sister-jules-1'


func _on_dad_pho_area_body_entered(body):
	if body.is_in_group('player') and talked_to_granny:
		start_convo('dad-phone')
