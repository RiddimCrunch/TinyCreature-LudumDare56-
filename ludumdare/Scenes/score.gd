extends Control


@onready var score = $Label

func setLabel(newLabel):
	score.text = str(newLabel)
