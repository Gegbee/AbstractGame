extends Node

var portraits = {
	"jeff doctor" : preload("res://Assets/DoctorPortrait.png"),
	"craig thompson" : preload("res://Assets/PatientPortrait.png")
}
var audio_bits = {
	"jeff doctor" : [
	preload("res://Assets/SampleNoise.wav"),
	preload("res://Assets/SampleNoise3.wav"),
	preload("res://Assets/SampleNoise4.wav"),
	preload("res://Assets/SampleNoise5.wav"),
	preload("res://Assets/SampleNoise6.wav")
	],
	"craig thompson" : [
	preload("res://Assets/SampleNoise.wav"),
	preload("res://Assets/SampleNoise3.wav"),
	preload("res://Assets/SampleNoise3.wav"),
	preload("res://Assets/SampleNoise4.wav"),
	preload("res://Assets/SampleNoise6.wav"),
	preload("res://Assets/SampleNoise6.wav")
	]
}
var dialog : CanvasLayer = null
