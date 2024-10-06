extends Node2D
class_name Ally

var health = 100

var state: AllyState = AllyState.wandering

var moveSpeed = 100
var target: Vector2
var target_set = false
var target_enemy: Enemy = null

@onready var wait_timer = $Timer
@onready var sprite = $Sprite2D


enum AllyState { in_combat, wandering, moving_and_looking, moving, waiting }

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	match state:
		AllyState.wandering:
			wander(delta)
		AllyState.in_combat:
			attack(delta)
		AllyState.moving_and_looking:
			pass
		AllyState.moving:
			move_torward_target(delta)
		AllyState.waiting:
			waiting(delta)
			
			
func cmd_set_target(cmd_target: Vector2, move_state: AllyState):
	target = cmd_target
	state = move_state
			

func waiting(delta: float):
	pass

func attack(delta: float):
	if (target_enemy == null):
		state = AllyState.wandering
		return
	
	target = target_enemy.position
	move_torward_target(delta)
	
func wander(delta: float):
	if (state != AllyState.wandering):
		pass
	
	if target_set:
		move_torward_target(delta)
	else:
		generate_target_position()
		
	
func generate_target_position():
	var angle = randi_range(0, 2 * PI)
	var radius = randi_range(100, 500)
	target.x = position.x + cos(angle) * radius
	target.y = position.y + sin(angle) * radius
	if (!get_viewport_rect().has_point(target)):
		generate_target_position()
	target_set = true
	
func move_and_look():
	pass
	
func move_torward_target(delta: float):
	var distance = target - position
	var direction = distance.normalized()
	position += (direction * delta * moveSpeed)
	var norm = distance.length()
	if (norm < 0.5 and state == AllyState.wandering):
		target_set = false
		state = AllyState.waiting
		if (wait_timer.is_stopped()):
			wait_timer.start(2)
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (!area.get_parent().is_in_group("Mechant")):
		return
	var enemy = area.get_parent()
	if (target_enemy == null and state != AllyState.moving):
		target_enemy = enemy
		state = AllyState.in_combat
		

func _on_timer_timeout() -> void:
	if (state == AllyState.waiting):
		state = AllyState.wandering
	wait_timer.stop()
