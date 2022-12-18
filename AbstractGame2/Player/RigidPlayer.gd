extends RigidBody2D

const SPEED = 40.0
const JUMP_VELOCITY = -90.0
const ACCEL = 1000.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_on_floor = false

var cur_npc = null
var cur_item :RigidBody2D = null

func _process(delta):
	if cur_item != null:
		var item_dir = Vector2(
			Input.get_axis("item_left", "item_right"), 
			Input.get_axis("item_up", "item_down")
		)
		$ItemHolder.position.x = move_toward($ItemHolder.position.x, item_dir.x, delta)
		$ItemHolder.position.y = move_toward($ItemHolder.position.y, item_dir.y - 7, delta)
		cur_item.add_constant_central_force(-(cur_item.global_position - $ItemHolder.global_position) * delta * 100.0)
		
func _physics_process(delta):
	if not is_on_floor:
		linear_velocity.y += gravity * delta
	if Input.is_action_just_pressed("jump") and is_on_floor:
		linear_velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction > 0:
		$PlayerStatic.flip_h = false
	elif direction < 0:
		$PlayerStatic.flip_h = true
	if direction:
		linear_velocity.x += direction * ACCEL * delta
		linear_velocity.x = clampf(linear_velocity.x, -SPEED, SPEED)
	else:
		linear_velocity.x = move_toward(linear_velocity.x, 0, delta * ACCEL)

func _integrate_forces(state):
	is_on_floor = false
	for i in range(0, state.get_contact_count()):
		if state.get_contact_local_normal(i) == Vector2(0, -1):
			is_on_floor = true
		
func _input(_event):
	if Input.is_action_just_pressed("interact"):
		for area in $InteractArea.get_overlapping_areas():
			if area.is_in_group('NPC'):
				pass
			elif area.is_in_group('Door'):
				Global.last_scene_door_index = area.door_index
				get_tree().current_scene.switch_scene(area.room_name)
	if Input.is_action_just_pressed("interact_item"):
		if cur_item != null:
			cur_item.get_node("CollisionShape2D").disabled = false
			cur_item.gravity_scale = 1.0
			cur_item = null
		for body in $InteractArea.get_overlapping_bodies():
			if body.is_in_group('Item'):
				cur_item = body
				cur_item.gravity_scale = 0.0
				cur_item.get_node("CollisionShape2D").disabled = true
				
func _on_interact_area_area_entered(area):
	if area.is_in_group('NPC'):
		if is_instance_valid(Global.indicators):
			Global.indicators.update('converse', true)
		if is_instance_valid(Global.dialog):
			Global.dialog.pot_dialog = Global.convos[area.convo]
			cur_npc = area
	elif area.is_in_group('Door'):
		if is_instance_valid(Global.indicators):
			Global.indicators.update('door', true)

func _on_interact_area_area_exited(area):
	if area.is_in_group('NPC'):
		if is_instance_valid(Global.indicators):
			Global.indicators.update('converse', false)
		if is_instance_valid(Global.dialog):
			if cur_npc == area:
				Global.dialog.pot_dialog = []
	elif area.is_in_group('Door'):
		if is_instance_valid(Global.indicators):
			Global.indicators.update('door', false)

func _on_interact_area_body_entered(body):
	if body.is_in_group('Item'):
		if is_instance_valid(Global.indicators):
			Global.indicators.update('item', true)

func _on_interact_area_body_exited(body):
	if body.is_in_group('Item'):
		if is_instance_valid(Global.indicators):
			Global.indicators.update('item', false)
