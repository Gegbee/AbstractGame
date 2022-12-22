extends Node

var portraits = {
	"jules" : preload("res://Assets/JulesPortraitS.png"),
	"sister" : preload("res://Assets/SisterPortraitS.png")
}
var audio_bits = {
	"jules" : [

	],
	"sister" : [

	]
}
var dialog : CanvasLayer = null
var last_scene_door_index : int = -1
var indicators = null
var tasks = null
var player = null

var convos = {
	"sister1-0" : [
		["Good mornin'", "jules", true],
		["Evening, julius.", "sister", true],
		["Close, but not my name.", "jules", true],
		["Shut up jules.", "sister", true],
		["Dad'll be here by tn so you better have some dinner sorted out.", "sister", true],
	],
	"sister1-1" : [
		["Jules I'm having trouble talkin rn", "sister", true],
		["oh...", "jules", true],
		["sorry", "jules", true],
	],
	"test_dialog" : [
		["fuck women!", "jules", true],
		["real", "sister", true],
		["ok you can go now jules.", "sister", true],
		["sorry ya.", "jules", true],
	],
}
