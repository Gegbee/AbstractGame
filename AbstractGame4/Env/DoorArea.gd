extends Area2D


export var collision : NodePath

func _ready():
	add_to_group('door')
	
func _on_body_exited(body):
	if body.is_in_group('player'):
		get_node(collision).set_deferred("disabled", false)


func _on_body_entered(body):
	if body.is_in_group('player'):
		get_node(collision).set_deferred("disabled", true)
