extends CanvasLayer

#premature dialog structure: ["dialog goes here", "name of speaker", picture:Texture]

var test_dialog = Global.convos["test_dialog"]

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
const STEP_SPEED : float = 0.04

@onready var t = $Control/HBoxContainer/CenterContainer/VBoxContainer/Dialog
@onready var n = $Control/HBoxContainer/CenterContainer/VBoxContainer/Name
@onready var p = $Control/HBoxContainer/TextureRect
@onready var a = $AnimationPlayer

# shit to do with audio
var audio_bit_frequency = 0.1 # frequency of how often an audio bit plays in a second when a character is speaking
var pitch_range = [0.2, 1.8]
@onready var audio_player = $AudioStreamPlayer


func _ready():
	Global.dialog = self
	t.text = ""
	n.text = ""
	p.texture = null
	p.pivot_offset = p.position/2
	randomize()
	
func _process(_delta):
	if Input.is_action_just_pressed("interact_dialog"):
		print(len(set_dialog))
		if state == NONE:
			start_conversation(pot_dialog.duplicate())
		else:
			nextAction()
		
func runDialog(new_dialog : Array):
	state = RUNNING
	
	if len(new_dialog) > 2:
		if new_dialog[2] == false:
			p.texture = null
		else:
			p.texture = Global.portraits[new_dialog[1]]
			a.play("PortraitBounce")
	n.text = new_dialog[1]
	t.visible_characters = 0
	t.text = new_dialog[0]
	$StepTimer.start(STEP_SPEED)

func finishRunningDialog():
	state = IDLE
	$StepTimer.stop()
	t.visible_characters = -1
	
func nextAction():
	if state == RUNNING:
		finishRunningDialog()
	elif state == IDLE:
		if len(set_dialog) > 0:
			runDialog(set_dialog[0])
			current_dialog = set_dialog[0]
			set_dialog.remove_at(0)
		else:
			state = NONE
			n.text = ""
			t.text = ""
			p.texture = null
			if is_instance_valid(Global.player):
				Global.player._set_disabled(false)
	elif state == NONE:
		state = IDLE
		nextAction()
		
func start_conversation(convo : Array):
	if len(set_dialog) <= 0:
		if is_instance_valid(Global.player):
			Global.player._set_disabled(true)
			Global.player.cur_npc.cur_convo_num += 1
		set_dialog = convo
		nextAction()

func play_audio_bit():
	if len(current_dialog) > 0:
		if len(Global.audio_bits[current_dialog[1]]) > 1:
			Global.audio_bits[current_dialog[1]].shuffle()
			$AudioStreamPlayer.stream = Global.audio_bits[current_dialog[1]][0]
			$AudioStreamPlayer.pitch_scale = randf_range(pitch_range[0], pitch_range[1])
			$AudioStreamPlayer.play()

func _on_step_timer_timeout():
	t.visible_characters += 1
	play_audio_bit()
	if t.visible_characters == len(t.text):
		finishRunningDialog()
	else:
		$StepTimer.start(STEP_SPEED)
