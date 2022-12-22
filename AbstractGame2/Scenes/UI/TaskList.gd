extends CanvasLayer


@onready var l1 = $Control/VBoxContainer/Label
@onready var l2 = $Control/VBoxContainer/Label2
@onready var l3 = $Control/VBoxContainer/Label3

var task_types = {
	"keys" : "! Find keys to leave house",
}

func _ready():
	for l in [l1, l2, l3]:
		l.hide()
	Global.tasks = self
	
	
func update(task : String, add : bool):
	for l in [l1, l2, l3]:
		if add:
			if l.text == "":
				l.text = task_types[task]
				l.show()
				break
		else:
			if l.text == task_types[task]:
				l.text = ""
				l.hide()
				break
