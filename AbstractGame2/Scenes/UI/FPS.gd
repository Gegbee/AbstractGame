extends CanvasLayer


func _process(delta):
	$Label.text = str(Engine.get_frames_per_second()) + " FPS"
