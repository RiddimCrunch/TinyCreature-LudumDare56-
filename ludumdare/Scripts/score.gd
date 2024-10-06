extends Control

@onready var score = $Label

func set_label(new_label):
	score.text = str(new_label)
