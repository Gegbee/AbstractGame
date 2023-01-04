extends Node

var player = null
var bg = null
var camera = null
var dialog = null
var time_hand = null

var portraits = {
	"p johnson" :  preload("res://Assets/PJPortrait.png"),
	"jules" : preload("res://Assets/JulesPortrait.png")
}
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
	"pj-intro" : {
		"participants" : ["jules", "p johnson"],
		"lock_player" : true,
		"interrupt" : true,
		# this is a convo
		"convo" : [
			# this is a line
			# [name, portrait, text, input_to_continue, time_if_no_input]
			["p johnson", "If you don’t wake up...", false, 1.0],
			["p johnson", "I’ll kill the next family member.", true],
			["jules", "WHO ARE YOU??!!", true],
			["p johnson", "Relax kid. I’m saving you", false, 1.0],
			["p johnson", "Those fuckers in reality are trying to kill you.", true],
			["jules", "Is this not...", false, 1.0],
			["jules", "... reality?", true],
			["p johnson", "Be real kid we’re in a videogame.", true],
			["p johnson", "The fuckers on the outside play us like toys.", false, 1.0],
			["jules", "What?", false, 0.7],
			["jules", "WHAT!", false, 0.9],
			["jules", "What in God’s name did I smoke last night.", true],
			["p johnson", "Nothing.", false, 0.8],
			["p johnson", "Look kid, I don't have time for questions.", false, 1.0],
			["p johnson", "Go back home.", true],
		]
	},
}
#“If you don’t wake up…; I’ll kill the next family member.”
#You wake up in the barn with Pickle Johnson
#“WHO ARE YOU??!!”
#“Relax kid. I’m saving you; Those fuckers in reality are trying to kill you.”
#“Is this not…; …reality?
#“Be real kid we’re in a videogame; The fuckers on the outside play us like toys.”
#“What?; WHAT!; What in God’s name did I smoke last night.”
#“Nothing.; Look kid, I don't have time for questions.; Go back home.”

