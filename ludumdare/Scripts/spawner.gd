extends Node2D

@export var creature_scene: PackedScene
@export var MobTable = preload("res://Scripts/mob_table.gd")

signal creature_spawned(creature: Ally)
var creature_cost = 100

# Called when the node enters the scene tree for the first time.
func spawn(_points_available: int) -> int:
	var spawner_location = $SpawnerPosition
	var longueur = 400
	while (_points_available >= creature_cost):
		var creature: Node2D = creature_scene.instantiate()
		creature.position = spawner_location.global_position + Vector2(randi_range(-longueur, longueur), randi_range(-longueur, longueur))
		add_child(creature)
		creature_spawned.emit(creature)
		_points_available -= creature_cost
	return _points_available
	
