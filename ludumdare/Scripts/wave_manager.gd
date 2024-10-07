extends Node
class_name WaveManager

@export_category("Enemy")
@export var EnemyScene: Array[PackedScene] 
@export var SpawnerArray: Array[Node2D]
@export_enum("Rock", "Paper", "Scissor") var enemyClass : int
@export_category("Spawn")
@export var count = 0
@export var arrayEnemy = []
@export var maxCount = 1

@onready var pauseMenu = $PauseMenu
@onready var timer = $Timer

var is_spawning = false

var spawn_timer: float = 0.0
var spawn_interval: float = 1.

var waveIndex = 0

func _ready() -> void:
	setSpawnerPosition()
	pauseMenu.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		if hideOpenMenu() == true:
			pauseMenu.hide()
			get_tree().paused = false
	else:
		if pauseMenu.visible:
			pauseMenu.hide()
			get_tree().paused = false
			
func start_spawning():
	if (!is_spawning):
		timer.start(1.5)
		is_spawning = true
		
func _process(_delta: float) -> void:
	pass
	
func spawnEnemy() -> void:
	var enemy = EnemyScene[0].instantiate()
	enemy.dead.connect(on_dead)
	enemy.position = SpawnerArray[randi_range(0,7)].global_position
	arrayEnemy.append(enemy)
	add_child(enemy)
	count += 1
	
func on_dead(enemy: Enemy):
	var index = arrayEnemy.find(enemy)
	if index < 0: return
	arrayEnemy.remove_at(index)

func setSpawnerPosition() -> void:
	var screen_size = get_viewport().get_visible_rect().size
	SpawnerArray[0].global_position = Vector2(0, 0)
	SpawnerArray[1].global_position = Vector2(screen_size.x /2., 0)
	SpawnerArray[2].global_position = Vector2(screen_size.x, 0)
	SpawnerArray[3].global_position = Vector2(0, screen_size.y / 2.)
	SpawnerArray[4].global_position = Vector2(screen_size.x, screen_size.y / 2.) 
	SpawnerArray[5].global_position = Vector2(0, screen_size.y)
	SpawnerArray[6].global_position = Vector2(screen_size.x / 2., screen_size.y)
	SpawnerArray[7].global_position = Vector2(screen_size.x, screen_size.y)

func clear_enemies() -> void:
	for enemy in arrayEnemy:
		enemy.queue_free()  
	arrayEnemy.clear()  
	count = 0

func hideOpenMenu():
	return pauseMenu.visible

func getWaveIndex():
	return waveIndex


func _on_timer_timeout() -> void:
	if waveIndex == 0: 
		if count < maxCount:
			spawnEnemy()
			count += 1
			waveIndex += 1 
	else:
		if arrayEnemy.size() == 0:
			maxCount += 3 + log(maxCount)
			print(maxCount)
			waveIndex += 1
		if count < maxCount:
			spawnEnemy()
		elif count >= maxCount:
			timer.stop()
			is_spawning = false
	print(waveIndex)
