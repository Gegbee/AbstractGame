extends Node

var player = null
var bg = null
var camera = null
var dialog = null
var time_hand = null


var convos = {
	# each of these dictionaries are complete_convos
	"test1-1" : {
		"participants" : ["johan", "willaker"],
		"lock_player" : false,
		"interrupt" : false,
		# this is a convo
		"convo" : [
			# this is a line
			# [name, portrait, text, input_to_continue, time_if_no_input]
			["johan", null, "light me up a ciggy will ya'", false, 0.7],
			["willaker", null, "I don't hav any on mei.", false, 0.7],
			["johan", null, "for godsake willy-", false, 0.4],
			["johan", null, "-get yor life in shape", false, 0.6],
			["willaker", null, "im soory johannes, i'll remember nextime.", false, 1.0]
		]
	},
	"sister-jules-greeting" : [
		["sister", null, "Evening, Julius", true],
		["Jules", null,  "It's morning...", false, 1.0],
		["Jules", null, "And that's not my-", false, 0.6],
		["sister", null, "Shut up Jules.", true]
		
	],
	"dad-jules-greeting" : {
		"participants" : ["Dad", "Jules"],
		"lock_player" : true,
		"interrupt" : false,
		"convo" : [
			["Dad", null, "Are you runnin' into town this morn?", false, 0.7],
			["Jules", null, "I can... you need anything?", true],
			["Dad", null, "Get me some salisbury steak.", false, 0.8],
			["Dad", null, "That s*** is delicious.", true]
		]
	}
}
#Dad: Are you running into town this morn?
#Jules: I can… you need anything?
#Dad: Get me some salisbury steak.
#Dad: That s*** is delicious.

