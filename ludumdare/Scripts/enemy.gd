extends RigidBody2D
class_name Enemy

var health = 100

var targetPosition = Vector2()

var move_speed = 50
var move_response = 5
var velocity_change = Vector2.ZERO

var rotationSpeed = 0.2
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
		
func _physics_process(_delta: float) -> void:
	apply_central_force(velocity_change * move_response)
		
func move_toward_center(_delta: float) -> void:
	var target_position_float = Vector2(targetPosition.x, targetPosition.y)
	var direction = (target_position_float - position).normalized()
	var target_velocity = direction * move_speed
	velocity_change = target_velocity - linear_velocity
	
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
	if (health <= 0):
		die()
		
func die():
	dead.emit(self)
	queue_free()


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Gentil"):
		apply_central_impulse(-body.velocity_change.normalized() * 150)
		return
