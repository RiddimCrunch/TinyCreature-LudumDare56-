extends Node
class_name WaveManager

@export_category("Enemy")
@export var EnemyScene: Array[PackedScene] 
@export var SpawnerArray: Array[Node2D]
@export_enum("Rock", "Paper", "Scissor") var enemyClass : int
@export_category("Spawn")
@export var count = 0
@export var arrayEnemy = []
@export var maxCount = 1000

var spawn_timer: float = 0.0
var spawn_interval: float = 1.

func _ready() -> void:
	setSpawnerPosition()


func _input(_event):
	if Input.get_action_strength("Jump"):
		clear_enemies()

func _process(_delta: float) -> void:
	#spawn_timer += _delta
	#if spawn_timer >= spawn_interval and count < maxCount:
	#	spawnEnemy()
	#	spawn_timer = 0.0  # Réinitialise le timer après chaque spawn
	if count < maxCount:
		spawnEnemy()

func spawnEnemy() -> void:
	var enemy = EnemyScene[0].instantiate()
	enemy.position = SpawnerArray[randi_range(0,7)].position
	arrayEnemy.append(enemy)
	add_child(enemy)
	count += 1

func setSpawnerPosition() -> void:
	SpawnerArray[0].position = Vector2(0, 0)
	SpawnerArray[1].position = Vector2(DisplayServer.screen_get_size().x /2., 0)
	SpawnerArray[2].position = Vector2(DisplayServer.screen_get_size().x, 0)
	SpawnerArray[3].position = Vector2(0, DisplayServer.screen_get_size().y / 2.)
	SpawnerArray[4].position = Vector2(DisplayServer.screen_get_size().x, DisplayServer.screen_get_size().y / 2.) 
	SpawnerArray[5].position = Vector2(0, DisplayServer.screen_get_size().y)
	SpawnerArray[6].position = Vector2(DisplayServer.screen_get_size().x / 2., DisplayServer.screen_get_size().y)
	SpawnerArray[7].position = Vector2(DisplayServer.screen_get_size().x, DisplayServer.screen_get_size().y)

func clear_enemies() -> void:
	for enemy in arrayEnemy:
		enemy.queue_free()  
	arrayEnemy.clear()  
	count = 0 
