extends Dialog2D

var spoken_to_pj : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_instance_valid(Global.player):
		Global.player.set_asleep(true)
	super()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_pjnpc_convo_finished(speaker, convo_name):
	if convo_name == 'pj-intro-1':
		speaker.cur_pot_convo = 'pj-intro-2'
		spoken_to_pj = true

func _on_exit_area_body_entered(body):
	if body.is_in_group('player'):
		if spoken_to_pj:
			get_tree().change_scene_to_file("res://OutsideMain.tscn")
