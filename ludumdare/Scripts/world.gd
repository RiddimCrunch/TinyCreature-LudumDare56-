extends Node2D


var point_counter = 0
var current_round = 0
var is_running = true
var allies = []
var game_state = GameState.between_combat
var hq_health = 500

enum GameState { in_combat, between_combat }

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not is_running:
		pass
	
	if game_state == GameState.between_combat:
		new_game()
	elif game_state == GameState.in_combat:
		in_combat()


func win_round(round: int):
	var gained_points = 20 * round + 200	
	point_counter += gained_points
	game_state = GameState.between_combat
	
func lose_round(round: int):
	pass
	
func new_game():
	$Spawner.spawn(point_counter)
	$WaveManager.spawnEnemy()
	current_round += 1
	game_state = GameState.in_combat
	
func in_combat():
	var enemies = $WaveManager.arrayEnemy
	
	for ally in allies:
		print(ally)
	for enemy in enemies:
		print(enemy)
	
	if (hq_health <= 0):
		lose_round(current_round)
	elif (enemies.is_empty()):
		win_round(current_round)
	elif (allies.is_empty()):
		lose_round(current_round)
		
	
	
	 
	
