extends StaticBody2D


# Features needed:

# Ability for time-based dialogue (check)
# Ability for player to skip dialogue ONLY when they are the ones talking
# Ability for player to initiate convo
# Ability for current convo to change based on time during the game and how many times player has talked to the NPC

var ex_convo = [
	# [name, image, dialogue, bool (is skippable?), time that dialogue lasts for after typed out (if time based)]
	["johan", preload("res://Assets/InriaSans-Bold.ttf"), "light me up a ciggy will ya'", false, 0.7],
	["willaker", preload("res://Assets/InriaSans-Bold.ttf"), "I don't hav any on mei.", false, 0.7],
	["johan", preload("res://Assets/InriaSans-Bold.ttf"), "for godsake willy-", false, 0.4],
	["johan", preload("res://Assets/InriaSans-Bold.ttf"), "-get yor life in shape", false, 0.6],
	["willaker", preload("res://Assets/InriaSans-Bold.ttf"), "im soory johannes, i'll remember nextime.", false, 1.0],
]
