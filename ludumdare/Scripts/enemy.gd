extends Node2D

var targetPosition = Vector2()
var moveSpeed = 100
var rotationSpeed = 2
var angle = 0
var radius =  100
var rotating = false

func _ready() -> void:
	randomize()
	modulate = Color(randf(), randf(), randf(), 1.0)
	targetPosition = DisplayServer.screen_get_size() / 2


func _process(delta: float) -> void:
	if rotating:
		rotate_around_center(delta) 
	elif position.distance_to(targetPosition) > radius:
		move_toward_center(delta) 
	else:
		start_rotating()
		
func move_toward_center(delta: float) -> void:
	var target_position_float = Vector2(targetPosition.x, targetPosition.y)
	var direction = (target_position_float - position).normalized()
	position += direction * moveSpeed * delta
	
func rotate_around_center(delta: float) -> void:
	angle += rotationSpeed * delta
	position.x = targetPosition.x + cos(angle) * radius
	position.y = targetPosition.y + sin(angle) * radius
	
func start_rotating() -> void:
	rotating = true  
	angle = atan2(position.y - targetPosition.y, position.x - targetPosition.x)

func _on_enemy_destroyed():
	var waveManager = get_node("/root/WaveManager")  #
	waveManager.count -= 1  
	queue_free()  
