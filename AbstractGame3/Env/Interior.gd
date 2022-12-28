extends Node2D

class_name Interior2D

@export var shape : NodePath

@export var interior_area : NodePath

func _ready():
	if has_node(interior_area):
		get_node(interior_area).connect('body_entered', Callable(self, '_door_entered'))
		get_node(interior_area).connect('body_exited', Callable(self, '_door_exited'))
		
func _door_entered(body):
	if body.is_in_group('player'):
		$Exterior.hide()
		if is_instance_valid(Global.bg):
			Global.bg.set_interior_bg(true)
func _door_exited(body):
	if body.is_in_group('player'):
		$Exterior.show()
		if is_instance_valid(Global.bg):
			Global.bg.set_interior_bg(false)
