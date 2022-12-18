extends CharacterBody2D


const SPEED = 40.0
const JUMP_VELOCITY = -90.0
const ACCEL = 1000.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var cur_npc = null

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	
	if direction > 0:
		$PlayerStatic.flip_h = false
	elif direction < 0:
		$PlayerStatic.flip_h = true
		
	if direction:
		velocity.x += direction * ACCEL * delta
		velocity.x = clampf(velocity.x, -SPEED, SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * ACCEL)

#	for i in get_slide_collision_count():
#		var collision = get_slide_collision(i)
#		if collision.get_collider() is RigidBody2D:
#			collision.get_collider().apply_central_impulse(-collision.get_normal() * 10.0)

	move_and_slide()
	
func _input(_event):
	if Input.is_action_just_pressed("interact"):
		for area in $InteractArea.get_overlapping_areas():
			if area.is_in_group('NPC'):
				pass
			elif area.is_in_group('Door'):
				Global.last_scene_door_index = area.door_index
				get_tree().current_scene.switch_scene(area.room_name)

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
