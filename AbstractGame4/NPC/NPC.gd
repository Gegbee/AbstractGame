extends Speaker2D

class_name NPC2D

# add stuff to be reactive to player movement just like pikuniku
export var pot_convos : Array = []

# this is for when interacted with, the convo will be played
var cur_pot_convo : String = ""

func _ready():
	add_to_group('npc')
	if len(pot_convos) > 0:
		cur_pot_convo = pot_convos[0]
#	lock_rotation = true
#	custom_integrator = true
#	max_contacts_reported = 5
#	contact_monitor = true
#	linear_damp = 10
#	angular_damp = 10
#	super()
	._ready()
	
func activate_pot_convo():
	if is_instance_valid(Global.dialog):
		Global.dialog.start_convo(cur_pot_convo)
