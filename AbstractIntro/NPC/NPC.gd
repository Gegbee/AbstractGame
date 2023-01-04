extends Speaker2D

class_name NPC2D

# add stuff to be reactive to player movement just like pikuniku
@export var pot_convos : Array = []
@export var is_static : bool = true
@export var head_sprite_path : NodePath
var hs
# this is for when interacted with, the convo will be played
var cur_pot_convo : String = ""
var starting_pos : Vector2 = Vector2()
var player_in_area = null


func _ready():
	add_to_group('npc')
	set_pot_convo()
	if head_sprite_path:
		hs = get_node(head_sprite_path)
	starting_pos = global_position
	super()
	
func activate_pot_convo():
	if is_instance_valid(Global.dialog):
		Global.dialog.start_convo(cur_pot_convo)
		$Notifier.noti("null")
		
func set_pot_convo():
	if len(pot_convos) > 0:
		cur_pot_convo = pot_convos[0]
	# $Notifier.noti("speaking")

func notify_near(near : bool):
	if cur_pot_convo == "":
		return
	if near:
		$Notifier.noti("speaking")
	else:
		$Notifier.noti("null")

func _integrate_forces(state):
	if (global_position - starting_pos).length() > 10 and is_static:
		linear_velocity += (-global_position + starting_pos) * state.step * 100.0

func _process(delta):
	if player_in_area:
		if hs:
			var rel_pos = player_in_area.global_position - global_position
			hs.rotation = lerp(hs.rotation, atan2(rel_pos.y, rel_pos.x) - PI/2, delta * 10.0)
