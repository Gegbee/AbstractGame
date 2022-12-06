extends Camera2D

# Lower cap for the `_zoom_level`.
var min_zoom := 0.1
# Upper cap for the `_zoom_level`.
var max_zoom := 1.0
# Controls how much we increase or decrease the `_zoom_level` on every turn of the scroll wheel.
var zoom_factor := 0.06
# Duration of the zoom's tween animation.
var zoom_duration := 0.2

# The camera's target zoom level.
var _zoom_level := (max_zoom-min_zoom)/2 setget _set_zoom_level
var prev_mouse_pos = Vector2()

# We store a reference to the scene's tween node.
onready var tween: Tween = Tween.new()

func _ready():
	add_child(tween)
	
func _set_zoom_level(value: float) -> void:
	# We limit the value between `min_zoom` and `max_zoom`
	_zoom_level = clamp(value, min_zoom, max_zoom)
	# Then, we ask the tween node to animate the camera's `zoom` property from its current value
	# to the target zoom level.
	tween.interpolate_property(
		self,
		"zoom",
		zoom,
		Vector2(_zoom_level, _zoom_level),
		zoom_duration,
		tween.TRANS_SINE,
		# Easing out means we start fast and slow down as we reach the target value.
		tween.EASE_OUT
	)
	tween.start()
	
func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("move_camera"):
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			global_position += event.relative / 2
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
	prev_mouse_pos = get_global_mouse_position()
	if event.is_action_pressed("zoom_in"):
		# Inside a given class, we need to either write `self._zoom_level = ...` or explicitly
		# call the setter function to use it.
		_set_zoom_level(_zoom_level - zoom_factor)
	if event.is_action_pressed("zoom_out"):
		_set_zoom_level(_zoom_level + zoom_factor)
