extends Node2D


var noti_symbols = {
	"Exclamation" : [preload("res://Assets/ExclamationNoti.png"), Vector2(8, -40)],
	"Question" : [preload("res://Assets/QuestionNoti.png"), Vector2(8, -40)],
	"Locked" : [preload("res://Assets/LockedNoti.png"), Vector2(8, -40)],
	"Unlocked" : [preload("res://Assets/UnlockedNoti.png"), Vector2(8, -40)],
	"Speaking" : [preload("res://Assets/SpeakingNoti.png"), Vector2(8, -40)],
}

func _ready():
	show()
	$Sprite2D.texture = null
	$Sprite2D.offset = Vector2()
	
func noti(noti_name):
	var new_texture = noti_symbols[noti_name][0]
	var texture_offset = noti_symbols[noti_name][1]
	$Sprite2D.texture = new_texture
	$Sprite2D.offset = texture_offset
	$Sprite2D.modulate.a = 1.0
	$AnimationPlayer.play('new_noti')
	
