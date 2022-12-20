extends Camera2D

var prev_mouse_pos = Vector2()

@export var moving : bool = false
var pot_player = null

func _ready():
	if moving:
		if is_instance_valid(get_parent().get_node("Player")):
			pot_player = get_parent().get_node("Player")
			position_smoothing_enabled = false
			await get_tree().process_frame
			position = pot_player.global_position + Vector2(0, -18 * 8)
			await get_tree().process_frame
			position_smoothing_enabled = true
			
func _process(_delta):
	if moving:
		if is_instance_valid(pot_player):
			position = pot_player.global_position + Vector2(0, -18 * 8)
			
func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("move_camera"):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			offset += event.relative / 2
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
	prev_mouse_pos = get_global_mouse_position()
