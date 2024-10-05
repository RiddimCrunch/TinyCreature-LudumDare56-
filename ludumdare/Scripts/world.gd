extends Node2D


var point_counter = 0
var current_round = 0
var is_running = true
var enemies = []
var allies = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_running:
		new_game()
		win_round(current_round)
		current_round += 1
		print(current_round)

func new_game():
	$Spawner.spawn(point_counter)

func win_round(round: int):
	var gained_points = 20 * round + 200	
	point_counter += gained_points
	
