extends RigidBody2D
class_name Ally

var health = 100

var state: AllyState = AllyState.wandering

var move_speed = 220
var move_response = 5
var velocity_change = Vector2.ZERO

var target: Vector2
var target_set = false
var target_enemy: Enemy = null

@onready var wait_timer = $Timer
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var type = $EntityType
@onready var flashTimer = $FlashTimer


signal dead(enemy: Ally)

enum AllyState { in_combat, wandering, moving_and_looking, moving, waiting }

func _ready() -> void:
	sprite.material.set_shader_parameter("flash_modifer", 0)

func _process(delta: float) -> void:
	match state:
		AllyState.wandering:
			wander(delta)
		AllyState.in_combat:
			attack(delta)
		AllyState.moving_and_looking:
			move_torward_target(delta, target)
		AllyState.moving:
			move_torward_target(delta, target)
		AllyState.waiting:
			waiting(delta)
			
	if state == AllyState.waiting and anim.is_playing():
		anim.play("RESET")
	elif not anim.is_playing():
		anim.play("wiggle_walk")
			
			
func cmd_set_target(cmd_target: Vector2, move_state: AllyState):
	target = cmd_target
	target_enemy = null
	state = move_state

func waiting(_delta: float):
	velocity_change = Vector2.ZERO - linear_velocity

func attack(delta: float):
	if (target_enemy == null):
		state = AllyState.moving_and_looking
		return
	
	move_torward_target(delta, target_enemy.position)
	
func wander(delta: float):
	if (state != AllyState.wandering):
		pass
	
	if target_set:
		move_torward_target(delta, target)
	else:
		generate_target_position()
		
	
func generate_target_position():
	var angle = randi_range(0, (int)(2 * PI))
	var radius = randi_range(10, 200)
	target.x = position.x + cos(angle) * radius
	target.y = position.y + sin(angle) * radius
	if (!get_viewport_rect().has_point(target)):
		generate_target_position()
	target_set = true
	
func _physics_process(_delta: float) -> void:
	apply_central_force(velocity_change * move_response)
	
func move_torward_target(_delta: float, t: Vector2):	
	
	var distance = t - position
	var target_velocity = distance.normalized() * move_speed
	velocity_change = target_velocity - linear_velocity
	
	var norm = distance.length()
	if (norm < 2):
		target_set = false
		state = AllyState.waiting
		if (wait_timer.is_stopped()):
			wait_timer.start(5)
			
	
func start_combat(enemy: Enemy):
	if ((target_enemy == null 
			or (target_enemy.type.type != type.type and enemy.type.type == type.type))
			and state != AllyState.moving):
		target_enemy = enemy
		state = AllyState.in_combat

func _on_area_2d_area_entered(area: Area2D) -> void:
	if (!area.get_parent().is_in_group("Mechant")):
		return
	var enemy = area.get_parent() 
	start_combat(enemy)
		

func _on_timer_timeout() -> void:
	if (state == AllyState.waiting):
		state = AllyState.wandering
	wait_timer.stop()
	
func receive_damage(dmg: float):
	health -= dmg
	if (health <= 0):
		die()
		
func die():
	dead.emit(self)
	queue_free()

func _on_body_entered(body: Node) -> void:
	if (!body.is_in_group("Mechant")):
		apply_central_impulse(-velocity_change.normalized() * 150)
		return
	apply_central_impulse(-velocity_change.normalized() * 750)

	start_combat(body)
	if body.type.type == type.type:
		body.receive_damage(20)
	else:
		receive_damage(50)
		flash()
	
func flash():
	sprite.material.set_shader_parameter("flash_modifer", 1)
	flashTimer.start()
	


func _on_flash_timer_timeout() -> void:
	sprite.material.set_shader_parameter("flash_modifer", 0)
	flashTimer.stop()
