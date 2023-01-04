extends CanvasModulate


@export var gradient : Gradient

var _t: float = 0.0
@export var time_for_full_cycle : float = 220.0

var time : float = 0.0
var day : int = 0
# time = 0 - 100
# when it would usually turn 101, the day switches and the time goes back to zero

func _ready():
	show()
	Global.time_hand = self

func _process(delta):
	_t += delta/time_for_full_cycle
	color = gradient.sample(_t)
	time += delta/time_for_full_cycle * 100.0
	if _t > 1.0: # Full cycle completed
		_t = 0.0
		day += 1
		time = 0.0
	$CanvasLayer/Label.text = "Day: " + str(day) + ", Time: " + str(int(time))
	#get_parent().get_node("WorldEnvironment").environment.glow_bloom = abs(_t)/10.0
