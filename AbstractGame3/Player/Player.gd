extends RigidBody2D

const SPEED = 140.0
const ACCEL = 800.0

var disabled = false : set = _set_disabled

var reset_state : bool = false
var reset_position : Vector2 = Vector2()
var new_rot : float = 0.0

func _ready():
	Global.player = self
	add_to_group('player')
	
func _set_disabled(new_disabled):
	disabled = new_disabled

func _process(_delta):
	pass
	
func _integrate_forces(state):
	if reset_state:
		var t = state.get_transform()
		t.origin.x = reset_position.x
		t.origin.y = reset_position.y
		state.set_transform(t)
		reset_state = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	direction = direction.normalized()
	
	if direction != Vector2() and !disabled:
		state.linear_velocity += direction * ACCEL * state.step
		state.linear_velocity.x = clampf(state.linear_velocity.x, -SPEED, SPEED)
		state.linear_velocity.y = clampf(state.linear_velocity.y, -SPEED, SPEED)
	else:
		state.linear_velocity.x = move_toward(state.linear_velocity.x, 0, state.step * ACCEL)
		state.linear_velocity.y = move_toward(state.linear_velocity.y, 0, state.step * ACCEL)
	
	if linear_velocity.length() >= 30.0:
		$Sprite.rotation = lerp_angle($Sprite.rotation, atan2(linear_velocity.y, linear_velocity.x) + PI/2, state.step * 20.0)



func _on_interact_area_area_entered(area):
	if area.is_in_group('door'):
		if is_instance_valid(Global.indicators):
			Global.indicators.update('door', true)

func _on_interact_area_area_exited(area):
	if area.is_in_group('door'):
		if is_instance_valid(Global.indicators):
			Global.indicators.update('door', false)
