extends ShadowSprite

var time : float = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta * 10.0
	if int(time * 10.0) % 2 == 0:
		scale.x = sin(time)
