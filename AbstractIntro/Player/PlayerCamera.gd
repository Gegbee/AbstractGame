extends Camera2D

var zoom_levels = {
	"interior" : Vector2(0.8, 0.8),
	"outside_walking" : Vector2(0.6, 0.6),
	"outside_driving" : Vector2(0.4, 0.4)
}
var target_zoom = "outside_walking"

func _ready():
	Global.camera = self
	
func set_target_zoom(_target_zoom):
	target_zoom = _target_zoom
	
func _process(delta):
	zoom.x = lerp(zoom.x, zoom_levels[target_zoom].x, delta * 1.0)
	zoom.y = lerp(zoom.y, zoom_levels[target_zoom].y, delta * 1.0)
