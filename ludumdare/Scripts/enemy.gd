extends RigidBody2D
class_name Enemy

var health = 100

var targetPosition = Vector2()
var moveSpeed = 50
var rotationSpeed = 2
var angle = 0
var radius =  100
var rotating = false

@onready var type: EntityType = $EntityType

signal dead(enemy: Enemy)

func _ready() -> void:
	randomize()
	type.change_type(randi_range(0,EntityType.TypeEnum.size()-1))
	targetPosition = get_viewport_rect().get_center()


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

func attackBase():
	pass
	
func attackGentil():
	pass
	
func receive_damage(dmg: float):
	health -= dmg
	print("received %s damage" % dmg)
	if (health <= 0):
		die()
		
func die():
	dead.emit(self)
	queue_free()
