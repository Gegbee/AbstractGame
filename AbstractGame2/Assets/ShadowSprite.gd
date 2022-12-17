extends Sprite2D

class_name ShadowSprite

@export var shadow_offset : Vector2 = Vector2()
@export_range (0.0, 1.0) var shadow_opacity : float = 0.5
var shadow : Sprite2D

func _ready():
	shadow = Sprite2D.new()
	add_child(shadow)
	if texture:
		shadow.texture = texture
	shadow.modulate = "000000"
	shadow.modulate.a = shadow_opacity
	shadow.z_as_relative = false
	shadow.z_index = z_index-1
	
func _process(_delta):
	if shadow.texture:
		shadow.global_position = global_position + shadow_offset
	else:
		if texture:
			shadow.texture = texture
