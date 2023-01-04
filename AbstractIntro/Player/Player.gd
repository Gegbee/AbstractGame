extends Speaker2D

const SPEED = 400.0
const ACCEL = 1800.0
var norm_speed : float = sqrt(2 * pow(SPEED, 2))
var disabled = false : set = set_disabled

var reset_state : bool = false
var reset_position : Vector2 = Vector2()
var new_rot : float = 0.0
var init_movement : bool = true

var npc_input_need : Speaker2D = null

func _ready():
	Global.player = self
	add_to_group('player')
	super()
	
func set_disabled(new_disabled):
	disabled = new_disabled
	print(disabled)
	freeze = disabled
	
func _input(_event):
	if Input.is_action_pressed('interact'):
		if npc_input_need != null:
			npc_input_need.next_dialog()
			npc_input_need = null
			return
		if cur_convo_name != "":
			return
		var npc = null
		var door = null
		var bed = null
		for body in $InteractArea.get_overlapping_bodies():
			if body.is_in_group('npc'):
				npc = body
			elif body.is_in_group('door') and !body.locked:
				door = body
		if door:
			if !disabled:
				pass
		elif bed:
			pass
		elif npc:
			npc.activate_pot_convo()
			
func _integrate_forces(state):
	if reset_state:
		var ts = state.get_transform()
		ts.origin.x = reset_position.x
		ts.origin.y = reset_position.y
		state.set_transform(t)
		reset_state = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down"))
	direction = direction.normalized()
	
	if !disabled:
		if direction.x != 0.0:
			linear_velocity.x += direction.x * ACCEL * state.step
		else:
			linear_velocity.x = move_toward(linear_velocity.x, 0, state.step * ACCEL)
		if direction.y != 0.0:
			linear_velocity.y += direction.y * ACCEL * state.step
		else:
			linear_velocity.y = move_toward(linear_velocity.y, 0, state.step * ACCEL)
		if linear_velocity.length() >= SPEED:
			linear_velocity = linear_velocity.normalized() * SPEED
	
	if linear_velocity.length() >= 30.0:
		if init_movement == true:
			$AnimationPlayer2.stop()
			$AnimationPlayer2.play("PlayerPop")
			init_movement = false
#		if abs(direction.dot(Vector2(cos(rotation), sin(rotation)))) > 0.5:
		$AnimationPlayer.play("FootWalking")
#		else:
#			$AnimationPlayer.play("Shuffle")
		$Sprite.rotation = lerp_angle($Sprite.rotation, atan2(linear_velocity.y, linear_velocity.x) - PI/2, state.step * 20.0)
		$Head.rotation = lerp_angle($Head.rotation, atan2(linear_velocity.y, linear_velocity.x) - PI/2, state.step * 6.0)
	else:
		init_movement = true
		$AnimationPlayer.play("FootIdle")

	
func _on_interact_area_area_entered(area):
	if area.is_in_group('door'):
		if is_instance_valid(Global.indicators):
			Global.indicators.update('door', true)

func _on_interact_area_area_exited(area):
	if area.is_in_group('door'):
		if is_instance_valid(Global.indicators):
			Global.indicators.update('door', false)
	

func _on_interact_area_body_entered(body):
	if body.is_in_group('npc'):
		body.notify_near(true)
		body.player_in_area = self

func _on_interact_area_body_exited(body):
	if body.is_in_group('npc'):
		body.notify_near(false)
		body.player_in_area = null
