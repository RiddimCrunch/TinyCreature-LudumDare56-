extends CharacterBody2D


const SPEED = 300.0


func _physics_process(_delta: float) -> void:
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	var upDirection := Input.get_axis("ui_up", "ui_down")
	if upDirection:
		velocity.y = upDirection * SPEED
	else:
		velocity.y = move_toward(velocity.y,0 , SPEED)

	move_and_slide()
