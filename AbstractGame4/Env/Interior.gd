extends Node2D

class_name Interior2D

export var interior_area : NodePath

func _ready():
	$Exterior.show()
	if has_node(interior_area):
		get_node(interior_area).connect('body_entered', self, '_door_entered')
		get_node(interior_area).connect('body_exited', self, '_door_exited')
		
func _door_entered(body):
	if body.is_in_group('player'):
		$Exterior.hide()
		if is_instance_valid(Global.bg):
			Global.bg.set_interior_bg(true)
		if is_instance_valid(Global.camera):
			Global.camera.set_target_zoom("interior")
			
func _door_exited(body):
	if body.is_in_group('player'):
		$Exterior.show()
		if is_instance_valid(Global.bg):
			Global.bg.set_interior_bg(false)
		if is_instance_valid(Global.camera):
			Global.camera.set_target_zoom("outside_walking")
