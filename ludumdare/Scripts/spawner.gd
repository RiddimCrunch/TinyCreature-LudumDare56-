extends Node2D

@export var creature_scene: PackedScene
@export var MobTable = preload("res://Scripts/mob_table.gd")

signal creature_spawned(creature: Ally)

# Called when the node enters the scene tree for the first time.
func spawn(points_available: int) -> void:
	var spawner_location = $SpawnerPosition
	
	for i in range(5):
		var creature = creature_scene.instantiate()
		var range = 500
		creature.position = spawner_location.global_position + Vector2(randi_range(-range, range), randi_range(-range, range))
		add_child(creature)
		creature_spawned.emit(creature)
		print("Spawned %s" % i)
	
