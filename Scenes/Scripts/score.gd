extends Control

var score = 0

@onready var label: Label = $Label

func add_score(amount):
	score += amount
	label.text = str(score)
