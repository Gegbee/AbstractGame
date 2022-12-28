extends Camera2D

var zoom_levels = {
	"interior" : Vector2(5, 5),
	"outside_walking" : Vector2(4, 4)
}
var target_zoom = "outside_walking"

func set_target_zoom(_target_zoom):
	target_zoom = _target_zoom
	
func _process(delta):
	zoom.x = move_toward(zoom.x, zoom_levels[target_zoom].x, delta * 5.0)
	zoom.y = move_toward(zoom.y, zoom_levels[target_zoom].y, delta * 5.0)
