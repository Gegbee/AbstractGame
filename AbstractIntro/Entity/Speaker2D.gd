extends RigidBody2D

class_name Speaker2D

#var text_path : NodePath
#var name_path : NodePath
#@export var texture_path : NodePath
#@export var animation_path : NodePath

@onready var p = $Dialog/Base/TextureRect
@onready var n = $Dialog/Base/VBoxContainer/Name
@onready var t = $Dialog/Base/Text
@onready var a = $Dialog/AnimationPlayer

var step_timer = Timer.new()
var end_timer = Timer.new()
const STEP_SPEED = 0.01

var cur_convo_name : String = ""
var cur_convo : Array = []
var cur_convo_pos : int = 0

func _ready():
#	p = get_node(texture_path)
#	n = get_node(name_path)
#	t = get_node(text_path)
#	a = get_node(animation_path)
	add_child(step_timer)
	add_child(end_timer)
	step_timer.connect('timeout', Callable(self, '_on_step_timer_timeout'))
	step_timer.one_shot = true
	end_timer.one_shot = true
	end_timer.connect('timeout', Callable(self, '_on_end_timer_timeout'))
	# n.text = ""
	t.text = ""
	p.texture = null
	a.play('Reset')
	
func join_convo(new_convo_name : String, new_convo_pos : int):
	cur_convo_name = new_convo_name
	cur_convo = Global.convos[new_convo_name]["convo"]
	cur_convo_pos = new_convo_pos
	roll_dialog(cur_convo[cur_convo_pos])

func leave_convo():
	cur_convo_name = ""
	cur_convo = []
	cur_convo_pos = 0
	print(name)
	
func in_convo() -> bool:
	if cur_convo != []:
		return true
	return false
	
func roll_dialog(new_dialog : Array):
	$Dialog.z_index = 12
	a.play('PopUp')
	if new_dialog[1] != null:
		p.texture = Global.portraits[new_dialog[0]]
	# n.text = new_dialog[0]
	t.visible_characters = 0
	t.text = new_dialog[1]
	step_timer.start(STEP_SPEED)

func finishRunningDialog():
	step_timer.stop()
	t.visible_characters = -1
	$Dialog.z_index = 11
	var ii_pos = t.position + t.size
	$Dialog/Base/InteractZ.position = ii_pos + Vector2(70, 10)
	$Dialog/Base/InteractZ.show()
	if !cur_convo[cur_convo_pos][2]:
		end_timer.start(cur_convo[cur_convo_pos][3])
		$Dialog/Base/InteractZ.texture = preload("res://Assets/InteractT.png")
	else:
		# player input to continue the conversation
		Global.player.npc_input_need = self
		$Dialog/Base/InteractZ.texture = preload("res://Assets/ZInteract.png")
		
func next_dialog():
	a.play('PopDown')
	$Dialog/Base/InteractZ.hide()
	
#func play_audio_bit():
#	if len(current_dialog) > 0:
#		if len(Global.audio_bits[current_dialog[1]]) > 1:
#			Global.audio_bits[current_dialog[1]].shuffle()
#			$AudioStreamPlayer.stream = Global.audio_bits[current_dialog[1]][0]
#			$AudioStreamPlayer.pitch_scale = randf_range(pitch_range[0], pitch_range[1])
#			$AudioStreamPlayer.play()

func _on_step_timer_timeout():
	t.visible_characters += 1
	# play_audio_bit()
	if t.visible_characters == len(t.text):
		finishRunningDialog()
	else:
		step_timer.start(STEP_SPEED)

func _on_end_timer_timeout():
	next_dialog()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "PopDown":
		# n.text = ""
		t.text = ""
		p.texture = null
		if len(cur_convo) == cur_convo_pos + 1:
			Global.dialog.end_convo(cur_convo_name)
		else:
			var next_convo_pos = cur_convo_pos + 1
			var next_speaker = Global.dialog.speakers[cur_convo[next_convo_pos][0]]
			next_speaker.join_convo(cur_convo_name, next_convo_pos)
