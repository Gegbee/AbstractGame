extends CollisionPolygon2D

class_name PolygonCopier2D

export var cp : NodePath 

func _ready():
	var np
	if has_node(cp):
		np = get_node(cp)
	polygon = np.polygon
	position = np.position
