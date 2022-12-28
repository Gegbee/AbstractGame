extends RigidBody2D

const SPEED = 40.0 * 6
const JUMP_VELOCITY = -90.0 * 7
const ACCEL = 1000.0 * 6

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
var is_on_floor = false

var cur_npc = null
var cur_item : Item2D = null
var item_dir : Vector2 = Vector2()
@onready var item_holder : Node2D = $Center/ItemHolder
var item_hold_mult = 50
var item_throw_mult = 800
@onready var left_arm = $Sprite/Torso/ArmJointL
@onready var right_arm = $Sprite/Torso/ArmJointR

var disabled = false : set = _set_disabled

var reset_state : bool = false
var reset_position : Vector2 = Vector2()

var last_anim : String = ""

func _ready():
	Global.player = self
	
func _set_disabled(new_disabled):
	disabled = new_disabled
#	if disabled:
#		if is_instance_valid(Global.indicators):
#			Global.indicators.hide()
#	else:
#		if is_instance_valid(Global.indicators):
#			Global.indicators.show()
			
func _process(delta):
	if cur_item != null:
		item_dir = Vector2(
			Input.get_axis("item_left", "item_right"), 
			Input.get_axis("item_up", "item_down")
		) * item_hold_mult
		if item_dir != Vector2():
			item_holder.position.x = move_toward(item_holder.position.x, item_dir.x, delta * 200.0)
			item_holder.position.y = move_toward(item_holder.position.y, item_dir.y, delta * 200.0)
		cur_item.linear_velocity = -(cur_item.global_position - item_holder.global_position) * delta * 500
		var l_to_item = -(cur_item.global_position - left_arm.global_position)
		var r_to_item = -(cur_item.global_position - left_arm.global_position)
		var langle_to_item : float = atan2(l_to_item.y, l_to_item.x) + PI/2
		var rangle_to_item : float = atan2(r_to_item.y, r_to_item.x) + PI/2
		left_arm.rotation = langle_to_item
		right_arm.rotation = rangle_to_item
	else:
		left_arm.rotation = lerp_angle(left_arm.rotation, PI/6, delta * 3)
		right_arm.rotation = lerp_angle(right_arm.rotation, -PI/6, delta * 3)
		
		
func _integrate_forces(state):
	if reset_state:
		var t = state.get_transform()
		t.origin.x = reset_position.x
		t.origin.y = reset_position.y
		state.set_transform(t)
		reset_state = false
		
	is_on_floor = false
	for i in range(0, state.get_contact_count()):
		if state.get_contact_local_normal(i).dot(Vector2.UP) > 0:
			is_on_floor = true

	if not is_on_floor:
		linear_velocity.y += gravity * state.step
	if !disabled and Input.is_action_just_pressed("jump") and is_on_floor:
		linear_velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction > 0:
		$PlayerStatic.flip_h = false
	elif direction < 0:
		$PlayerStatic.flip_h = true

	if direction and !disabled:
		linear_velocity.x += direction * ACCEL * state.step
		linear_velocity.x = clampf(linear_velocity.x, -SPEED, SPEED)
	else:
		linear_velocity.x = move_toward(linear_velocity.x, 0, state.step * ACCEL)

	if abs(linear_velocity.x) > 1:
		change_animation_state("Walking")
	else:
		change_animation_state("Idle")

		
func _input(_event):
	if Input.is_action_just_pressed("interact"):
		var npc_area = null
		var door_area = null
		var bed_area = null
		for area in $InteractArea.get_overlapping_areas():
			if area.is_in_group('NPC'):
				npc_area = area
			elif area.is_in_group('Door') and !area.locked:
				door_area = area
			elif area.is_in_group('Bed'):
				bed_area = area
		if npc_area:
			if is_instance_valid(Global.dialog):
				Global.dialog.next_input()
				return
		elif door_area:
			if !disabled:
				Global.last_scene_door_index = door_area.door_index
				get_tree().current_scene.switch_scene(door_area.room_name)
				return
		elif bed_area:
			if Global.time_of_day == Global.NIGHT:
				if is_instance_valid(Global.indicators):
					Global.indicators.update('bed_down', false)
					Global.indicators.update('bed_up', true)
				change_animation_state("BedDown")
				Global.change_time(Global.DAY)
				_set_disabled(true)
			else:
				if last_anim == "BedDown":
					if is_instance_valid(Global.indicators):
						Global.indicators.update('bed_up', false)
					change_animation_state("BedUp")
					_set_disabled(false)
				
	# DROPPING AND PICKING UP ITEM
	if Input.is_action_just_pressed("interact_item"):
		if cur_item != null:
			cur_item.get_node(cur_item.collision_ref).disabled = false
			cur_item.gravity_scale = 1.0
			cur_item.apply_central_impulse(item_holder.position.normalized() * item_throw_mult)
			cur_item = null
			if is_instance_valid(Global.indicators):
				Global.indicators.update('item_use', false)
		else:
			for body in $InteractArea.get_overlapping_bodies():
				if body.is_in_group('Item'):
					if cur_item == null:
						cur_item = body
						cur_item.gravity_scale = 0.0
						cur_item.get_node(cur_item.collision_ref).disabled = true
						if is_instance_valid(Global.indicators):
							Global.indicators.update('item_use', true)
					
					
func _on_interact_area_area_entered(area):
	if disabled:
		return
	if area.is_in_group('NPC'):
		cur_npc = area
		update_dialog()
		if area.force_dialog and area.cur_convo_num == 0:
			if is_instance_valid(Global.dialog):
				#_set_disabled(true)
				Global.dialog.start_conversation(Global.dialog.pot_dialog.duplicate())
		if is_instance_valid(Global.indicators):
			Global.indicators.update('converse', true)
	elif area.is_in_group('Door'):
		if area.immediate:
			Global.last_scene_door_index = area.door_index
			get_tree().current_scene.switch_scene(area.room_name)
		else:
			if is_instance_valid(Global.indicators):
				Global.indicators.update('door', true)
	elif area.is_in_group('Bed'):
		if is_instance_valid(Global.indicators) and Global.time_of_day == Global.NIGHT:
			Global.indicators.update('bed_down', true)
				
func update_dialog():
	if is_instance_valid(Global.dialog):
		var convo : int = 0
		if cur_npc.cur_convo_num >= cur_npc.num_of_convos:
			convo = cur_npc.num_of_convos - 1
		else:
			convo = cur_npc.cur_convo_num
		Global.dialog.pot_dialog = Global.convos[cur_npc.convo + "-" + str(convo)]
	
func _on_interact_area_area_exited(area):
	if disabled:
		return
	if area.is_in_group('NPC'):
		if is_instance_valid(Global.indicators):
			Global.indicators.update('converse', false)
		if is_instance_valid(Global.dialog):
			if cur_npc == area:
				Global.dialog.pot_dialog = []
	elif area.is_in_group('Door'):
		if is_instance_valid(Global.indicators):
			Global.indicators.update('door', false)
	elif area.is_in_group('Bed'):
		if is_instance_valid(Global.indicators):
			Global.indicators.update('bed_down', false)
					
func _on_interact_area_body_entered(body):
	if body.is_in_group('Item'):
		if is_instance_valid(Global.indicators):
				Global.indicators.update('item_pickup', true)

func _on_interact_area_body_exited(body):
	if body.is_in_group('Item'):
		if is_instance_valid(Global.indicators):
			Global.indicators.update('item_pickup', false)

func change_animation_state(new_state : String):
#	if $AnimationPlayer.current_animation == new_state:
#		return
	if $AnimationPlayer.current_animation != "":
		last_anim = $AnimationPlayer.current_animation
	print(last_anim + " -> " + new_state)
	if last_anim == "BedUp":
		if !$AnimationPlayer.is_playing():
			$AnimationPlayer.play(new_state)
	elif last_anim == "BedDown":
		if new_state == "BedUp":
			$AnimationPlayer.play(new_state)
	elif last_anim == "Walking":
		$AnimationPlayer.play(new_state)
	elif last_anim == "Idle":
		$AnimationPlayer.play(new_state)
