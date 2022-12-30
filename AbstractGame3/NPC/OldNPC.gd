extends StaticBody2D


# Features needed:

# Ability for time-based dialogue (check)
# Ability for player to skip dialogue ONLY when they are the ones talking
# Ability for player to initiate convo
# Ability for current convo to change based on time during the game and how many times player has talked to the NPC

var ex_convo = [
	# [name, image, dialogue, bool (is skippable?), time that dialogue lasts for after typed out (if time based)]
	["johan", null, "light me up a ciggy will ya'", false, 0.7],
	["willaker", null, "I don't hav any on mei.", false, 0.7],
	["johan", null, "for godsake willy-", false, 0.4],
	["johan", null, "-get yor life in shape", false, 0.6],
	["willaker", null, "im soory johannes, i'll remember nextime.", false, 1.0],
]

var test_dialog = ex_convo

enum {
	NONE,
	RUNNING,
	IDLE
}
var state : int = NONE
var set_dialog : Array = []
var pot_dialog : Array = []
var current_dialog = []
var current_step := -1
const STEP_SPEED : float = 0.02

@onready var t = $Text/HBoxContainer/VBoxContainer/Dialog
@onready var n = $Text/HBoxContainer/VBoxContainer/Name
@onready var p = $Text/HBoxContainer/TextureRect
# @onready var a = $AnimationPlayer

# shit to do with audio
#var audio_bit_frequency = 0.1 # frequency of how often an audio bit plays in a second when a character is speaking
#var pitch_range = [0.2, 1.8]
#@onready var audio_player = $AudioStreamPlayer


func _ready():
	Global.dialog = self
	t.text = ""
	n.text = ""
	p.texture = null
	p.pivot_offset = p.position/2
	randomize()
	pot_dialog = test_dialog
	next_input()

func _process(delta):
	if is_instance_valid(Global.player):
		var distance_to_player : float = (Global.player.global_position - global_position).length()
		if distance_to_player <= 100.0:
			$Text.modulate.a = -(distance_to_player - 100.0) / 100.0 * 255.0
		else:
			if state != NONE:
				t.text = "..."
		
func runDialog(new_dialog : Array):
	state = RUNNING
	
	if new_dialog[1] != null:
		p.texture = new_dialog[1]
			# a.play("PortraitBounce")
	n.text = new_dialog[0]
	t.visible_characters = 0
	t.text = new_dialog[2]
	$StepTimer.start(STEP_SPEED)


func finishRunningDialog():
	state = IDLE
	$StepTimer.stop()
	t.visible_characters = -1
	if current_dialog[3]:
		pass
		# Player can skip this dialogue
	else:
		$ConvoTimer.start(current_dialog[4])
	
func nextAction():
	if state == RUNNING:
		finishRunningDialog()
	elif state == IDLE:
		if len(set_dialog) > 0:
			t.visible_characters = 0
			runDialog(set_dialog[0])
			current_dialog = set_dialog[0]
			set_dialog.remove_at(0)
		else:
			state = NONE
			n.text = ""
			t.text = ""
			p.texture = null
#			if is_instance_valid(Global.player):
#				Global.player._set_disabled(false)
#				Global.player.update_dialog()
	elif state == NONE:
		state = IDLE
		nextAction()
		
		
func start_conversation(convo : Array):
	if len(set_dialog) <= 0 and len(convo) > 0:
#		if is_instance_valid(Global.player):
#			Global.player._set_disabled(true)
#			Global.player.cur_npc.cur_convo_num += 1
		set_dialog = convo
		nextAction()


func next_input():
	if state == NONE:
		start_conversation(pot_dialog.duplicate())
	else:
		nextAction()
		
		
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
		$StepTimer.start(STEP_SPEED)

func _on_convo_timer_timeout():
	next_input()
