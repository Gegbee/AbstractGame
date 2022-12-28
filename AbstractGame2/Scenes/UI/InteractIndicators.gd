extends CanvasLayer


@onready var l1 = $Control/CenterContainer/VBoxContainer/Label
@onready var l2 = $Control/CenterContainer/VBoxContainer/Label2
@onready var l3 = $Control/CenterContainer/VBoxContainer/Label3

var indicator_types = {
	"door" : "[Z] Door",
	"converse" : "[Z] Talk",
	"continue_converse" : "[Z] Continue",
	"item_pickup" : "[C] Use item",
	"item_use" : "[WASD + C] Throw",
	"bed_down" : "[Z] Sleep",
	"bed_up" : "[Z] Wake up"
}

func _ready():
	for l in [l1, l2, l3]:
		l.hide()
		l.text = ""
	Global.indicators = self
	
	
func update(indication : String, add : bool):
	if add:
		if indicator_exists(indication):
			return
	else:
		if !indicator_exists(indication):
			return
			
	for l in [l1, l2, l3]:
		if add:
			if l.text == "":
				l.text = indicator_types[indication]
				l.show()
				break
		else:
			if l.text == indicator_types[indication]:
				l.text = ""
				l.hide()
				break

func indicator_exists(indication: String):
	for l in [l1, l2, l3]:
		if l.text == indicator_types[indication]:
			return true
	return false
