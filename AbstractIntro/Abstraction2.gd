extends Dialog2D


func _ready():
	if is_instance_valid(Global.player):
		Global.player.set_asleep(true)
	super()
