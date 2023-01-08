extends Node

var player = null
var bg = null
var camera = null
var dialog = null
var time_hand = null

var portraits = {
	"p johnson" :  preload("res://Assets/PJPortrait.png"),
	"jules" : preload("res://Assets/JulesPortrait.png"),
	"dad" : preload("res://Assets/DadPortrait.png"),
	"sister" : preload("res://Assets/SisterPortrait.png"),
	"worker" : preload("res://Assets/OfficerPortrait.png"),
	"officer" : preload("res://Assets/OfficerPortrait.png"),
	"granny" : preload("res://Assets/OfficerPortrait.png")
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
	"pj-intro-1" : {
		"participants" : ["jules", "p johnson"],
		"lock_player" : true,
		"interrupt" : true,
		# this is a convo
		"convo" : [
			# this is a line
			# [name, portrait, text, input_to_continue, time_if_no_input]
			["p johnson", "Thank god you’re awake...", true],
			["p johnson", "I’m not tryna be a babysitter.", true],
			["jules", "WHO ARE YOU??!!", true],
			["p johnson", "Relax kid, I’m saving you.", false, 1.0],
			["p johnson", "You just fell out of reality", true],
			["jules", "Is this not...", false, 1.0],
			["jules", "...where am I?", true],
			["p johnson", "The abstraction, Jules.", true],
			["p johnson", "I’m gonna give you one more chance at reality.", true],
			["jules", "What?", false, 0.7],
			["jules", "WHAT!", false, 0.9],
			["jules", "What in God’s name did I smoke last night.", true],
			["p johnson", "Nothing.", false, 0.8],
			["p johnson", "Just don't f*** up again, and you'll be fine.", true]
		]
	},
	"pj-intro-2" : {
		"participants" : ["jules", "p johnson"],
		"lock_player" : true,
		"interrupt" : true,
		# this is a convo
		"convo" : [
			# this is a line
			# [name, portrait, text, input_to_continue, time_if_no_input]
			["p johnson", "I can’t leave here until you leave as well...", false, 1.0],
			["p johnson", "...and if you come back...", true],
			["p johnson", "...that means there is something very... very wrong.", true],
		]
	},
	"dad-1" : {
		"participants" : ["jules", "dad", "sister"],
		"lock_player" : true,
		"interrupt" : true,
		# this is a convo
		"convo" : [
			# this is a line
			# [name, portrait, text, input_to_continue, time_if_no_input]
			["dad", "Jules!", true],
			["sister", "...bleuh uhh help im dying", false, 0.5],
			["dad", "Shut up Eleanor!", true],
			["dad", "Where in Christ’s name have you been Jules!?", true],
			["jules", "I was… I don’t know.", true],
			["dad", "You can't just dissapear like that.", true],
		]
	},
	"dad-2" : {
		"participants" : ["jules", "dad"],
		"lock_player" : false,
		"interrupt" : true,
		# this is a convo
		"convo" : [
			# this is a line
			# [name, portrait, text, input_to_continue, time_if_no_input]
			["dad", "Christ damn it are you bored jules?", false, 1.0],
			["dad", "Go check up on Granny Ellis if need somethin' to do.", false, 2.0],
		]
	},
	"worker-1" : {
		"participants" : ["jules", "worker"],
		"lock_player" : true,
		"interrupt" : true,
		# this is a convo
		"convo" : [
			# this is a line
			# [name, portrait, text, input_to_continue, time_if_no_input]
			["worker", "Got a problem?", true],
			["jules", "Sorry, heard ya mumbling.", true],
			["worker", "You alr kid.", true],
			["worker", "Don't mind me, I just do the gov'ners dirty work...", true],
			["worker", "Do the repairin' for em.", true],
		]
	},
	"officer-granny" : {
		"participants" : ["officer", "granny"],
		"lock_player" : true,
		"interrupt" : true,
		# this is a convo
		"convo" : [
			# this is a line
			# [name, portrait, text, input_to_continue, time_if_no_input]
			["officer", "Look Mrs. Ellis...", true],
			["officer", "...it's just part of Gov’ner Randall’s campaign.", true],
			["granny", "You mean these damn signs are permanent?", true],
			["officer", "No Mrs. Ellis...", false, 1.0],
			["officer", "These signs are... uhh", false, 1.0],
			["officer", "just here until power is restored.", false, 1.0],
			["granny", "Power? The FUCK you mean power?", true],
			["granny", "I lived here for 127 years and never... NEVER...", false, 1.0],
			["granny", "Have I seen a sign so utterly demeaning.", true],
			["officer", "Well... part of Randall’s appeal is that, well...", false, 1.0],
			["officer", "he’s racist.", true],
			["granny", "Well how bout’ you tell him to go FUCK himself.", true],
		]
	},
	"jules-granny-1" : {
		"participants" : ["jules", "granny"],
		"lock_player" : true,
		"interrupt" : true,
		# this is a convo
		"convo" : [
			# this is a line
			# [name, portrait, text, input_to_continue, time_if_no_input]
			["jules", "Hey Granny... you alr?", true],
			["granny", "Thanks for asking Jules...", true],
			["granny", "Our stupid Gov’ner is promotin' his stupid agenda RIGHT by MY house.", true],
			["jules", "Why are you mad at Gov’ner Randall?", true],
			["granny", "Jules... you father and Randall are good buddies, but...", true], 
			["granny", "...they are both trash bag homophobes and racists.", true],
			["jules", "I thought that protest they went to was for freedom tho?", true],
			["granny", "That was no protest sonny... that was an insurrection", true],
			["granny", "don’t tell your father I said this", false, 1.0],
			["granny", "I’m not tryna make enemies at 127 years old.", true],
		]
	},
	"jules-granny-2" : {
		"participants" : ["jules", "granny"],
		"lock_player" : true,
		"interrupt" : true,
		# this is a convo
		"convo" : [
			# this is a line
			# [name, portrait, text, input_to_continue, time_if_no_input]
			["granny", "just ain't the same anymore...", true],
		]
	},
	"jules-sister-1" : {
		"participants" : ["jules", "sister"],
		"lock_player" : true,
		"interrupt" : true,
		# this is a convo
		"convo" : [
			# this is a line
			# [name, portrait, text, input_to_continue, time_if_no_input]
			["sister", "bleuhh uhh im dying!", false, 1.0],
			["sister", "HELPP{P HELPP!!!", true],
			["jules", "eleanor I don't understand when you jus' make noises.", true],
			["jules", "gawd damn...", true],
		]
	},
	"dad-phone" : {
		"participants" : ["dad", "phone"],
		"lock_player" : true,
		"interrupt" : true,
		# this is a convo
		"convo" : [
			# this is a line
			# [name, portrait, text, input_to_continue, time_if_no_input]
			["dad", "I don’t care what the hell you do...", false, 0.8],
			["dad", "She needs them drugs to survive", false, 0.8],
			["dad", "You are killing her! You realize that right?", true],
			["phone", "Sir... if I had God’s power I’d send the meds straight into your house...", true],
			["phone", "...unfortunately, we live in America.", true],
			["dad", "America is the land of the free.", true],
			["dad", "I will not pay TEN thousand of hard cash for a bull delivery system!", true],
			["phone", "Look sir…", false, 0.8],
			["phone", "We’ll see what we can do.", true],
		]
	},
	"dad-3" : {
		"participants" : ["dad", "jules"],
		"lock_player" : true,
		"interrupt" : true,
		# this is a convo
		"convo" : [
			# this is a line
			# [name, portrait, text, input_to_continue, time_if_no_input]
			["jules", "Hey papa… I’m home before midnight!", true],
			["dad", "That’s great Jules :|", true],
			["jules", "Is eleanor gonna be okay?", true],
			["dad", "Yes, she will…", true],
			["dad", "Don’t worry ellie I’ll save you.", true],
			["dad", "I’m gonna get you down to the hospital morrow.", true],
			["dad", "Jules will take care of the house.", true],
			["dad", "Ain’t that right Julius?", true],
		]
	},
	"pj-reentrance" : {
		"participants" : ["p johnson", "jules"],
		"lock_player" : true,
		"interrupt" : true,
		# this is a convo
		"convo" : [
			# this is a line
			# [name, portrait, text, input_to_continue, time_if_no_input]
		]
	},
	
}
