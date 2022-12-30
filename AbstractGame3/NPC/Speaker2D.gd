extends Node2D

class_name Speaker2D

@export var text_path : NodePath
@export var name_path : NodePath
@export var texture_path : NodePath
var p
var n
var t

var step_timer = Timer.new()
const STEP_SPEED = 0.02

func _ready():
	p = get_node(texture_path)
	n = get_node(name_path)
	t = get_node(text_path)
	add_child(step_timer)
	step_timer.connect('timeout', Callable(self, '_on_step_timer_timeout'))
	roll_dialog(Global.convos["sister-jules-greeting"][0])
	
func roll_dialog(new_dialog : Array):
	if new_dialog[1] != null:
		p.texture = new_dialog[1]
	n.text = new_dialog[0]
	t.visible_characters = 0
	t.text = new_dialog[2]
	step_timer.start(STEP_SPEED)

func finishRunningDialog():
	step_timer.stop()
	t.visible_characters = -1

		
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
