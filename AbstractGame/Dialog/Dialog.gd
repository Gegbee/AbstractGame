extends CanvasLayer

#premature dialog structure: ["dialog goes here", "name of speaker", picture:Texture]
var test_dialog = [
	["sir, your kid is dying", "jeff doctor", true],
	["uh... can you shut the fuck, I'm smoking a ciggy.", "craig thompson", true],
	["jesus man do you not care about your child? He has second hand smoke because of your cig addiction!", "jeff doctor", true]
]
onready var ltween = $LabelTween

enum {
	NONE,
	RUNNING,
	IDLE
}
var state : int = NONE
var set_dialog : Array = []
var low = false
var cinematic_mode: bool = false
var current_dialog = []

onready var t = $Control/VBoxContainer/CenterContainer/VBoxContainer/Dialog
onready var n = $Control/VBoxContainer/CenterContainer/VBoxContainer/Name
onready var p = $Control/VBoxContainer/TextureRect
onready var a = $AnimationPlayer

var buffer_interact : int = 0

# shit to do with audio
var audio_bit_frequency = 0.1 # frequency of how often an audio bit plays in a second when a character is speaking
var pitch_range = [0.2, 1.8]
onready var audio_player = $AudioStreamPlayer


func _ready():
	Global.dialog = self
	t.text = ""
	n.text = ""
	p.rect_pivot_offset = p.rect_position/2
	randomize()
	
func _process(_delta):
	if Input.is_action_just_pressed("interact"):
		print(len(set_dialog))
		if state == NONE:
			start_conversation(test_dialog.duplicate())
		else:
			nextAction()
#	if t.percent_visible == 1:
#		state = IDLE
	if t.percent_visible >= 1:
		current_dialog = []
		
func runDialog(new_dialog : Array):
	state = RUNNING
	
	if len(new_dialog) > 2:
		if new_dialog[2] == false:
			p.texture = null
		else:
			p.texture = Global.portraits[new_dialog[1]]
			a.play("PortraitBounce")
	n.text = new_dialog[1]
	t.percent_visible = 0
	t.text = new_dialog[0]
	ltween.interpolate_property(t, "percent_visible", 0, 1, 
	float(len(t.text)) / 30.0, 
	Tween.TRANS_LINEAR, 
	Tween.EASE_OUT)
		
	ltween.start()
	ltween.start()
	
	# audio stuff
	$AudioTimer.start(audio_bit_frequency)
	play_audio_bit()
		
func finishRunningDialog():
	ltween.reset_all()
	ltween.remove_all()
	state = IDLE
	var balls = false if t.percent_visible < 1 else true
	t.percent_visible = 1
	return balls
	
func nextAction():
	if state == RUNNING:
		var finished = finishRunningDialog()
		if finished:
			nextAction()
	elif state == IDLE:
		if len(set_dialog) > 0:
			runDialog(set_dialog[0])
			current_dialog = set_dialog[0]
			set_dialog.remove(0)
		else:
			state = NONE
			n.text = ""
			t.text = ""
			p.texture = null
	elif state == NONE:
		state = IDLE
		nextAction()
		
func start_conversation(convo : Array):
	if len(set_dialog) <= 0:
		set_dialog = convo
		nextAction()


func _on_AudioTimer_timeout():
	play_audio_bit()
	if len(current_dialog) > 0:
		$AudioTimer.start(audio_bit_frequency)

func play_audio_bit():
	if len(current_dialog) > 0:
		Global.audio_bits[current_dialog[1]].shuffle()
		$AudioStreamPlayer.stream = Global.audio_bits[current_dialog[1]][0]
		$AudioStreamPlayer.pitch_scale = rand_range(pitch_range[0], pitch_range[1])
		$AudioStreamPlayer.play()
