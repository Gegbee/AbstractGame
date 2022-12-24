extends Node2D


var time : float = 0.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta * 1.0
	rotation = sin(time) / 12
