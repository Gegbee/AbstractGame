extends RigidBody2D

class_name Item2D

@export var collision_ref : NodePath

var reset_position : Vector2 = Vector2()
var reset_state : bool = false

func _ready():
	add_to_group("Item")

func _integrate_forces(state):
	if reset_state:
		var t = state.get_transform()
		t.origin.x = reset_position.x
		t.origin.y = reset_position.y
		state.set_transform(t)
		reset_state = false
