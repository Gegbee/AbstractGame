extends Polygon2D

class_name CollisionGenerator2D

export var cp : NodePath 

func _ready():
	var np
	if has_node(cp):
		np = get_node(cp)
	else:
		np = CollisionPolygon2D.new()
		get_parent().call_deferred("add_child", np)
	np.polygon = polygon
	np.position = position
