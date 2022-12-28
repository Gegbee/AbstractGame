extends CanvasLayer

enum {
	INSIDE,
	OUTSIDE_DAY,
	OUTSIDE_NIGHT
}
var state = INSIDE

func _ready():
	Global.bg = self
	
func change_bg_state(new_state):
	if state == new_state:
		return
	if new_state == INSIDE:
		$ColorRect.color = "#000000"
	elif new_state == OUTSIDE_DAY:
		$ColorRect.color = "#90b4b6"
	elif new_state == OUTSIDE_NIGHT:
		$ColorRect.color = "#100c22"

func change_bg(color : String):
	$ColorRect.color = color
