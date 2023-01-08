extends Camera2D


@export var is_static : bool = false


var zoom_levels = {
	"interior" : Vector2(0.5, 0.5),
	"outside_walking" : Vector2(0.5, 0.5),
	"outside_driving" : Vector2(0.3, 0.3)
}
var target_zoom = "outside_walking"

func _ready():
	Global.camera = self
	
func set_target_zoom(_target_zoom):
	target_zoom = _target_zoom
	
func _process(delta):
	if !is_static and is_instance_valid(Global.player):
		global_position = Global.player.global_position
	zoom.x = lerp(zoom.x, zoom_levels[target_zoom].x, delta * 1.0)
	zoom.y = lerp(zoom.y, zoom_levels[target_zoom].y, delta * 1.0)
