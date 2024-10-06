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


func _input(_event):
	if Input.get_action_strength("Escape"):
		if hideOpenMenu() == true:
			pauseMenu.hide()
		else:
			pauseMenu.show()
			
func start_spawning():
	if (!is_spawning):
		timer.start(1)
		is_spawning = true
		
func _process(_delta: float) -> void:
	pass
	
func spawnEnemy() -> void:
	var enemy = EnemyScene[0].instantiate()
	enemy.position = SpawnerArray[randi_range(0,7)].position
	arrayEnemy.append(enemy)
	add_child(enemy)
	count += 1

func setSpawnerPosition() -> void:
	SpawnerArray[0].position = Vector2(0, 0)
	SpawnerArray[1].position = Vector2(1152 /2., 0)
	SpawnerArray[2].position = Vector2(1152, 0)
	SpawnerArray[3].position = Vector2(0, 648 / 2.)
	SpawnerArray[4].position = Vector2(1152, 648 / 2.) 
	SpawnerArray[5].position = Vector2(0, 648)
	SpawnerArray[6].position = Vector2(1152 / 2., 648)
	SpawnerArray[7].position = Vector2(1152, 648)

func clear_enemies() -> void:
	for enemy in arrayEnemy:
		enemy.queue_free()  
	arrayEnemy.clear()  
	count = 0 

func hideOpenMenu():
	return pauseMenu.visible

func getWaveIndex():
	print(waveIndex)


func _on_timer_timeout() -> void:
	if waveIndex == 0: 
		if count < maxCount:
			spawnEnemy()
			count += 1
			waveIndex += 1 
	else:
		if arrayEnemy.size() == 0:
			maxCount *= 1.3 + 1
			print(maxCount)
			waveIndex += 1
		if count < maxCount:
			spawnEnemy()
		elif count >= maxCount:
			timer.stop()
			is_spawning = false
	print(waveIndex)
