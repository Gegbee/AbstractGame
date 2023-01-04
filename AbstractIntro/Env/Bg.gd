extends Node2D

# Overall Bg layer is -10
# Everything outside = -9 -> -2
# Interior Bg layer is -1
# Player z-index is 0
# Everything Interior = 2 -> 9
# Exterior of buildings = 10

func _ready():
	Global.bg = self
	$InteriorBg.hide()
	
func set_interior_bg(active : bool):
	if active:
		$InteriorBg.show()
		get_tree().get_current_scene().get_node("AbovePlayerOutside").hide()
	else:
		$InteriorBg.hide()
		get_tree().get_current_scene().get_node("AbovePlayerOutside").show()
