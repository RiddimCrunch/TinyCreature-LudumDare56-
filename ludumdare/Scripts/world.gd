extends Node2D


var current_points = 600
var total_points = 0
var current_round = 0
var is_running = true
var allies = []

var red_count = 0
var green_count = 0
var blue_count = 0

var game_state = GameState.between_combat
var hq_health = 100
signal dmg_taken(hp: int)

enum GameState { in_combat, between_combat }

@onready var score = $Score
@onready var round = $Round

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		is_running = true
		game_state = GameState.in_combat
		new_game()
		
func hq_take_damage(dmg: int):
	print(hq_health)
	hq_health -= dmg
	dmg_taken.emit(hq_health)

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
	var gained_points = clamp((100 * manche), 0, 700) + 300	
	current_points += gained_points
	total_points += gained_points
	score.set_label(total_points)
	game_state = GameState.between_combat
	
func lose_round(_manche: int):
	get_tree().change_scene_to_file("res://Scenes/Menu/GameOverMenu.tscn")
	
func new_game():
	current_points = $Hq.spawn(current_points)
	$WaveManager.start_spawning()
	current_round += 1
	round.set_label("Round %s" % current_round)
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
	if current_round != 0:
		$AudioStreamPlayer2D.play()
	if red_count <= blue_count and red_count <= green_count:
		red_count+=1
		creature.type.change_type(0)
	elif blue_count <= red_count and blue_count <= green_count:
		blue_count+=1
		creature.type.change_type(2)
	else: 
		green_count+=1
		creature.type.change_type(1)
	
func _on_creature_death(creature: Ally):
	var index = allies.find(creature)
	if index < 0: return
	allies.remove_at(index)
	match creature.type.type:
		EntityType.TypeEnum.red:
			red_count-=1
		EntityType.TypeEnum.green:
			green_count-=1
		EntityType.TypeEnum.blue:
			blue_count-=1
