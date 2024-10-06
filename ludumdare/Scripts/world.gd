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
		is_running = true
		game_state = GameState.in_combat
		new_game()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not is_running:
		pass
	
	if game_state == GameState.between_combat:
		new_game()
	elif game_state == GameState.in_combat:
		check_win_lose()
		
		
func _input(_event):
	if Input.get_action_strength("Jump"):
		$WaveManager.clear_enemies()
		$WaveManager.start_spawning()


func win_round(manche: int):
	var gained_points = 20 * manche + 200	
	point_counter += gained_points
	game_state = GameState.between_combat
	
func lose_round(_manche: int):
	pass
	
func new_game():
	$Hq.spawn(point_counter)
	$WaveManager.start_spawning()
	current_round += 1
	game_state = GameState.in_combat
	
func check_win_lose():
	var enemies = $WaveManager.arrayEnemy
	
	if (hq_health <= 0):
		lose_round(current_round)
	elif (enemies.is_empty() and !$WaveManager.is_spawning):
		win_round(current_round)
	elif (allies.is_empty()):
		lose_round(current_round)
		
	
func _on_hq_creature_spawned(creature: Ally) -> void:
	creature.dead.connect(_on_creature_death)
	allies.append(creature) # Replace with function body.
	
func _on_creature_death(creature: Ally):
	var index = allies.find(creature)
	if index < 0: return
	allies.remove_at(index)
