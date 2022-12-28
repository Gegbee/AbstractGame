extends Node

var portraits = {
	"jules" : preload("res://Assets/JulesPortraitS.png"),
	"sister" : preload("res://Assets/SisterPortraitS.png")
}
var audio_bits = {
	"jules" : [

	],
	"sister" : [

	],
	"man named jim" : [
		
	]
}
var dialog : CanvasLayer = null
var last_scene_door_index : int = 0
var indicators = null
var tasks = null
var player = null
var bg = null

enum {
	DAY,
	NIGHT
}
var time_of_day = NIGHT

var convos = {
	"sister1-0" : [
		["Good mornin'", "jules", true],
		["Evening, julius.", "sister", true],
		["Close, but not my name.", "jules", true],
		["Shut up jules.", "sister", true],
		["You doin anything today?", "sister", true],
		["Nuthn planned...", "jules", true],
		["How bout' you get dad some salisbury steak meals for dinners.", "sister", true],
		["He needs a surprise bout; now.", "sister", true],
		["Aye aye, captain!", "jules", true],
	],
	"sister1-1" : [
		["Rember: salisbury steak...", "sister", true],
		["Only two tho, I can't eat that s***", "sister", true],
		["<sigh>", "sister", true],
	],
	"test_dialog" : [
		["f*** women!", "jules", true],
		["real", "sister", true],
		["ok you can go now jules.", "sister", true],
		["sorry ya.", "jules", true],
	],
	"hobbo1-0" : [
		["Quite out here is'nt it?", "jules", true],
		["Aye.", "man named jim", false],
		["You need something kid?", "man named jim", false],
		["I wish.", "jules", true],
		["Just look in your mind.", "man named jim", false],
		["Loads of interesting s*** there.", "man named jim", false],
	]
}

func change_time(new_time):
	print(str(time_of_day) + " -> " + str(new_time))
	if new_time == Global.DAY:
		# player is goin to sleep
		time_of_day = new_time
	else:
		# player is inside checkpoint, going from day to night
		time_of_day = new_time
